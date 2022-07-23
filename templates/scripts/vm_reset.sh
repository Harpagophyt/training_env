#!/bin/bash

if [[ $EUID > 0 ]]
then
	echo "You must be root" >&2
	exit 1
fi

if [[ $# == 0 ]]
then
	echo "Usage: $0 { all | vm_name }" >&2
	exit 2
fi

if [ "$1" == "all" ]
then
	for vm in {{ vms | map(attribute='name') | list | join(' ') }}
	do
		virsh snapshot-revert --domain ${vm} --snapshotname initial && \
		echo VM ${vm} finished
	done
else
	virsh snapshot-revert --domain ${1}  --snapshotname initial && \
	echo VM ${1} finished
fi
	
