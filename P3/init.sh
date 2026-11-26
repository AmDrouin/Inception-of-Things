#!/bin/bash

echo "----------------Installation Docker------------"
sudo pacman -Syu --noconfirm docker

echo "----------------Lancement Docker et add user group------------"
sudo systemctl reset-failed docker.service 2>/dev/null || true
sudo systemctl enable --now docker.socket docker.service
until sudo docker info >/dev/null 2>&1; do
    sleep 1
done
sudo usermod -aG docker "$USER"

echo "----------------Installation kubectl------------"
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mkdir -p /usr/local/bin
sudo mv kubectl /usr/local/bin/

echo "----------------Installation k3d------------"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "----------------Creation cluster---------"
k3d cluster create adrouinC -a 1

echo "----------------Creation namespace---------"
kubectl create namespace argocd --context k3d-adrouinC
kubectl create namespace dev --context k3d-adrouinC

echo "----------------Setup deployement------------"
sh ./deployement.sh
