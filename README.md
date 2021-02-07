# Torch Docker for RL development
This repository contains a dockerfile for use in RL Generalization Reserach.

It will setup a container with following technologies:
* Ubuntu 18.04
* CUDA 11.0
* Python 3
* Pytorch
* Torchvision
* OpenAI Gym

## Building && installation

### Requirements

* Nvidia GPU with CUDA (C.C. >= 5.0)
* nvidia driver for >= CUDA 11.0
* Docker with GPU support

### Docker image
For `zsh` shell please use following script:
```bash
zsh ./build.sh
```

### VNC client
Install `x11vnc` for render preview.
Arch:
```bash
sudo pacman -S x11vnc
```

Ubuntu:
```bash
sudo apt install x11vnc
```
## Usage

Run `torch_devel` container with bind-mount to current directory:
```bash
cd /path/to/working/dir
torch_devel
```

Connecting to `xvfb` server in container:
```bash

```

## Notes

Exposed ports:

| Port | Description |
| ---- | ----------- |
| 8888 | Jupyter-lab |
| 6006 | Tensorboard |
| 5900 | xvfb server |

