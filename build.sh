#!/usr/bin/env bash

TAG='0.1.6'

if [ $# -eq 0 ]
  then
    echo "Building torch_docker with tag ${TAG}"
  else
    tag=$1
fi

docker build -t labvault:5000/agh/torch_devel:$TAG .

sed -i '/torch_devel/d' ~/.bashrc
echo "alias torch_devel='docker run -p 8888:8888 -p 6006:6006 -v \$(pwd):/mnt/ws --gpus all labvault:5000/agh/torch_devel:${TAG}'" >> ~/.bashrc
echo "Added "torch_devel" allias to ~/.bashrc"
