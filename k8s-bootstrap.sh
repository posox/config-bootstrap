#!/bin/bash

set -e

sudo usermod -aG docker vagrant

wget https://raw.githubusercontent.com/openstack/fuel-ccp-installer/master/registry/registry-pod.yaml -O /tmp/pod.yaml
wget https://raw.githubusercontent.com/openstack/fuel-ccp-installer/master/registry/service-registry.yaml -O /tmp/service.yaml
kubectl create -f /tmp/pod.yaml --namespace=kube-system
kubectl create -f /tmp/service.yaml --namespace=kube-system
rm -f /tmp/pod.yaml /tmp/service.yaml

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
