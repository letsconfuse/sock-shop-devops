#!/bin/bash
set -e
set -o pipefail

echo "Starting Kubernetes node setup..."

apt-get update -y
apt-get upgrade -y
apt-get install -y curl wget git

echo "Installing Docker..."
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "Kubernetes node setup completed successfully" >> /var/log/k8s-setup.log
