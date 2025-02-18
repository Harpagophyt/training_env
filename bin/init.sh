#!/bin/bash
sudo -v
sudo dnf config-manager --set-enabled crb
sudo dnf install epel-release epel-next-release
sudo dnf makecache -y
sudo dnf install -y git ansible-core nmap openssh-askpass python3-paramiko
ansible-galaxy install -r requirements.yml
