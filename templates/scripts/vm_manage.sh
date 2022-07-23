#!/bin/bash

if [[ $EUID > 0 ]]
then
        echo "You must be root" >&2
        exit 1
fi

if [[ $# != 2 ]]
then
        echo "Usage: $0 { all | vm_name } { start | shutdown | destroy }" >&2
	echo "start    - means start"
	echo "shutdown - means shutdown"
	echo "destroy  - means forced shutdown"
        exit 2
fi

if [ "$1" == "all" ]
then
        for vm in {{ vms | map(attribute='name') | list | join(' ') }}
        do
                virsh $2 --domain ${vm} && \
                echo VM ${vm} $2 finished
        done
else
	virsh $2 --domain ${1} && \
	echo VM ${1} $2 finished
fi

