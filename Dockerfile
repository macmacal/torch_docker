FROM nvcr.io/nvidia/cuda:10.1-devel-ubuntu18.04
LABEL maintainer "Maciej Aleksandrowicz<macale@student.agh.edu.pl>"

# ---------------------------------------------------------------------------- #
# CONFIG
ENV CUDNN_VERSION 7.6.5.32
ENV PYTORCH_TAG=v1.4.0a0
ENV TORCHVISION_TAG=v0.5.0
ENV TORCH_CUDA_ARCH_LIST="5.0;7.5"

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

# ---------------------------------------------------------------------------- #
# cuDNN + Pytorch

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    libomp-dev \
    vim \
    mc \
    tmux \
    && apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /ws && mkdir /mnt/ws
WORKDIR /ws

#User is needed for miniconda env
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /ws && chown -R user:user /mnt/ws
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

ENV HOME=/home/user
RUN chmod 777 /home/user

ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/home/user/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda install -y python==3.6.9 \
 && conda clean -ya

#CUDA 10.1-specific steps for BUILD
RUN cd /ws

# DOWNLOAD SOURCE AND CHECKOUTS
RUN git clone --depth 1 --branch ${PYTORCH_TAG} --recursive https://github.com/pytorch/pytorch
RUN cd pytorch

# INSTALL DEPENDENCIES
RUN conda install numpy pyyaml mkl mkl-include setuptools cmake cffi typing
RUN conda install -c pytorch magma-cuda101

# SET ENV VARIABLES
ENV CUDNN_LIB_DIR="/usr/local/cuda-10.1/lib64"
ENV CUDNN_INCLUDE_DIR="/usr/local/cuda-10.1/include"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

# BUILD PACKAGE
RUN cd pytorch && python3 setup.py sdist bdist_wheel && echo "Finished building torch at $(date)" 

RUN cd /ws/pytorch/dist && python3 -m pip install ./torch-*.whl

# DELOCATING DYNAMIC LIBRARIRES LINKS
#RUN find ./ -name "*.whl" | xargs -I {} delocate-wheel -v {} && find ./ -name "*.whl" | xargs -I {} delocate-listdeps {} && echo "Finished deolcating at $(date)"


# ---------------------------------------------------------------------------- #
# torchvision

RUN cd /ws && git clone --depth 1 --branch ${TORCHVISION_TAG} --recursive https://github.com/pytorch/vision.git

RUN cd vision && python3 setup.py sdist bdist_wheel && echo "Finished building torchvision at $(date)"

RUN cd /ws/vision/dist && python3 -m pip install ./torchvision-*.whl

# ---------------------------------------------------------------------------- #
# jupyter-lab

RUN python3 -m pip install jupyterlab
EXPOSE 8888
RUN mkdir -p /home/user/.jupyter && (echo "c.NotebookApp.ip = '*'"; echo "c.NotebookApp.notebook_dir = '/mnt/ws'")  >> /home/user/.jupyter/jupyter_notebook_config.py

# Default command
CMD ["jupyter-lab"]
