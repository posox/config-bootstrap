#!/bin/bash

set -e

sudo usermod -aG docker vagrant

wget https://raw.githubusercontent.com/openstack/fuel-ccp-installer/master/registry/registry-pod.yaml /tmp
wget https://raw.githubusercontent.com/openstack/fuel-ccp-installer/master/registry/service-registry.yaml /tmp
kubectl create -f /tmp/registry-pod.yaml --namespace=kube-system
kubectl create -f /tmp/service-registry.yaml --namespace=kube-system

sudo apt install -y python3-dev

git clone https://git.openstack.org/openstack/fuel-ccp

pushd fuel-ccp
cat << "EOF" > ./conf.ini
[builder]
push = true

[registry]
address = localhost:31500
EOF
tox -e venv -- ccp fetch
popd
