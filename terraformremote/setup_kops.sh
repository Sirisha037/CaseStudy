#!/bin/bash
set -x  # Enable debugging

KOPS_STATE_STORE="s3://siri-kops-state-store-unique"
export KOPS_STATE_STORE="s3://siri-kops-state-store-unique"

# Update the package manager and install necessary packages
sudo yum update -y
sudo yum install -y --allowerasing golang curl jq

# Download and install kOps
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops

# Download and install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Create the Kubernetes cluster


kops create cluster --name=siri.k8s.local --state=s3://siri-kops-state-store-unique --zones=ap-south-1a --node-count=2 --node-size=t2.micro --control-plane-size=t2.micro --dns-zone=siri.k8s.local

