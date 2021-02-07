#!/bin/zsh

TAG='0.1.9'
echo "Building torch_docker with tag ${TAG}"

start=`date +%s`
docker build -t labvault:5000/agh/torch_devel:$TAG .
end=`date +%s`
echo "Container builded in $((end-start)) s"

sed -i '/torch_devel/d' ~/.zshrc;
echo "alias torch_devel='docker run -p 8888:8888 -p 6006:6006 -p 5900:5900 -v \$(pwd):/mnt/ws --gpus all labvault:5000/agh/torch_devel:${TAG}'" >> ~/.zshrc
echo "Added "torch_devel" allias to ~/.zshrc" 
source ~/.zshrc;
echo "Sourced ~/.zshrc"
