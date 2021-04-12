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
Install `tigervnc` for render preview.

Arch:
```bash
sudo pacman -S tigervnc
```

Ubuntu:
```bash
sudo apt install tigervnc
```
## Usage

Run `torch_devel` container with bind-mount to current directory:
```bash
cd /path/to/working/dir
torch_devel
```

Connecting to `xvnc` server in container (password: `1234`):
```bash
vncviewer localhost:0
```

## Notes

Exposed ports:

| Port | Description |
| ---- | ----------- |
| 5900 | xvfb server |
| 6006 | Tensorboard |
| 6099 | x11vnc      |
| 8888 | Jupyter-lab |
