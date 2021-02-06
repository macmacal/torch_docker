# Torch Docker for RL development
This repository contains a dockerfile for use in RL Generalization Reserach.

It will setup a container with following technologies:
* Ubuntu 18.04
* CUDA 11.0
* Python 3
* Pytorch
* Torchvision
* OpenAI Gym


## Building && instalation

For `bash` shell please use following script:
```bash
bash ./build.sh
source ~/.bashrc
```

For `zsh` shell please use:
```bash
zsh ./build.zsh
source ~/.zshrc
```

## Usage
Type:
```bash
cd /path/to/working/dir
torch_devel
```
Runs `torch_devel` docker with bind-mount to current directory.
