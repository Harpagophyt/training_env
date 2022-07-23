#!/bin/bash

for ip in {{ vms | map(attribute='network.0') | map(attribute='ip') | list | join(' ') }}
do
	sshpass -p {{ vm_root_password }} ssh \
		-o StrictHostKeyChecking=no \
                -o ConnectTimeout=1 \
		-o UserKnownHostsFile=/dev/null \
		-o LogLevel=ERROR \
		root@${ip} \
		hostnamectl | fgrep "Static hostname: " \
                sed -Ee 's/^ *(.+)/UP \1/'
done
	
