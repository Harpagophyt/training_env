#!/bin/bash
if [ $# -ne 1 ]
then
	echo Usage: $0 IP/CIDR
	echo Example: $0 192.168.1.0/24
fi
nmap -sn ${1} -oG - | awk '/Status: Up/{print $2}' | sort -V > /tmp/ips
echo /tmp/ips erzeugt
