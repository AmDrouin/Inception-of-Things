#!/bin/bash
set -e

curl -sfL https://get.k3s.io | sh -

mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
mkdir -p /var/lib/rancher/k3s/server/manifests
cp /vagrant/secret-postgres.yaml /var/lib/rancher/k3s/server/manifests/
cp /vagrant/postgresql-app.yaml /var/lib/rancher/k3s/server/manifests/
cp /vagrant/nginx-app.yaml /var/lib/rancher/k3s/server/manifests/