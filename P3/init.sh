#!/bin/bash

echo "----------------Installation Docker------------"
sudo pacman -S --needed --noconfirm docker

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

echo "----------------Creation cluster, namespaces et ArgoCD---------"
sudo -u "$USER" bash << 'EOF'
set -e

echo "----------------Creation cluster----------------"
k3d cluster create adrouinC -a 1 -p "8080:30080@server:0" -p "8888:30888@server:0"

echo "----------------Creation namespace----------------"
kubectl create namespace argocd
kubectl create namespace dev

echo "----------------Installation argoCD----------------"
kubectl apply --server-side --namespace argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "----------------Attente du demarrage d'ArgoCD----------------"
kubectl rollout status deployment/argocd-server -n argocd --timeout=180s

echo "----------------Port Mapping argocd----------------"
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort","ports":[{"name":"https","port":443,"targetPort":8080,"nodePort":30080}]}}'

echo "----------------Deployment argocd----------------"
kubectl apply -f ./confs/argocd-app.yaml -n argocd 

echo "----------------Get argocd admin password----------------"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
EOF