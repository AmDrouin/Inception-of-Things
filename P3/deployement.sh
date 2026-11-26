#!/bin/bash
set -e

# sudo mkdir -p /var/lib/rancher/k3s/server/manifests
# sudo cp confs/will-app.yaml /var/lib/rancher/k3s/server/manifests/
kubectl apply -f confs/will-app.yaml