#!/bin/bash
# Install K3s on the server node
curl -sfL https://get.k3s.io | sh -
# Get the token for the worker nodes
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
# Store the token for the workers to use
echo $TOKEN > /vagrant/token