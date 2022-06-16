#!/bin/bash

dnf install -y epel-release
dnf makecache -y
dnf install -y git ansible-core nmap openssh-askpass
ansible-galaxy install -r requirements.yml
