#!/bin/bash
sudo -v
sudo dnf install -y epel-release
sudo dnf makecache -y
sudo dnf install -y git ansible-core nmap openssh-askpass
ansible-galaxy install -r requirements.yml
