#!/bin/bash

echo "----------------Installation Docker------------"
sudo pacman -Syu --noconfirm docker
echo "----------------Lancement Docker et add user group------------"
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
echo "----------------Installation kubectl------------"
sudo pacman -S --noconfirm kubectl
echo "----------------Installation k3d------------"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "----------------Creation cluster---------"
k3d cluster create adrouinC -a 1
echo "----------------Creation namespace---------"
sudo kubectl create namespace --cluster adrouinC argocd
sudo kubectl create namespace --cluster adrouinC dev

