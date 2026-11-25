#!/bin/bash

sudo pacman -Syu --noconfirm git curl docker
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
sudo pacman -S --noconfirm kubectl
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

