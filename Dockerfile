# based Dockerfiles links from https://hub.docker.com/r/nvidia/cuda

FROM nvcr.io/nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04
LABEL maintainer "Maciej Aleksandrowicz<macale@student.agh.edu.pl>"

# ---------------------------------------------------------------------------- #
# CONFIG

ENV \
  PYTHON_VERSION="3.8.5" \
  CUDNN_LIB_DIR="/usr/local/cuda-11.0/lib64" \
  CUDNN_INCLUDE_DIR="/usr/local/cuda-11.0/include" \
  DEBIAN_FRONTEND="noninteractive" \
  X11VNC_PASSWORD="password" \
  TZ="Europe/Warsaw"

EXPOSE 5900 6006 6099 8888

# ---------------------------------------------------------------------------- #
# Utility tools

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    unzip \
    libx11-6 \
    libomp-dev \
    vim \
    mc \
    tmux \
    python-opengl \
    xvfb \
    x11vnc \
    ratpoison \
    xterm \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# ---------------------------------------------------------------------------- #
# Configure timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
 && dpkg-reconfigure -f noninteractive tzdata

# ---------------------------------------------------------------------------- #
# Create an user
RUN mkdir /mnt/ws \
 && adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /mnt/ws \
 && chmod 777 /home/user \
 && echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user \
 && ln -s /mnt/ws /home/user/ws
USER user
ENV HOME=/home/user


# ---------------------------------------------------------------------------- #
# Miniconda environment

ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/home/user/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda install -y python==${PYTHON_VERSION} \
 && conda clean -ya

# ---------------------------------------------------------------------------- #
# Pytorch + torchvision + python packages + jupyter-lab

RUN python3 -m pip install torch==1.7.1+cu110 torchvision==0.8.2+cu110 -f https://download.pytorch.org/whl/torch_stable.html
RUN python3 -m pip install \
    gym \
 && conda install \
    tensorboard \ 
    jupyterlab \
    matplotlib \
    pandas \
    pyyaml \
 && mkdir -p /home/user/.jupyter \
 && (echo "c.NotebookApp.ip = '*'"; echo "c.NotebookApp.notebook_dir = '/mnt/ws'")  >> /home/user/.jupyter/jupyter_notebook_config.py \
 && conda clean -ya \
 && rm -r /home/user/.cache/pip



# ---------------------------------------------------------------------------- #
# Entrypoint config
USER root
COPY "container-start.sh" "/opt/container-start.sh"
COPY "xsession-start.sh" "/opt/xsession-start.sh"
RUN chmod +x "/opt/container-start.sh" "/opt/xsession-start.sh"

USER user
CMD ["/opt/container-start.sh"]
