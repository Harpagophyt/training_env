#!/usr/bin/bash

if [ $USER != "root" ]
then
    echo Start $0 as root >&2
    exit 1
fi

sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*
dnf update
dnf install centos-release-stream
dnf swap centos-{linux,stream}-repos
dnf distro-sync
echo +-----------------------+
echo \| Reboot is recommended \|
echo +-----------------------+
exit 0