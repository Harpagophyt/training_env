#!/usr/bin/env python3

import paramiko

username = "root"
password = "{{ vm_root_password }}"
#hosts = ["10.0.1.1", "10.0.1.2", "10.0.1.3", "10.0.1.4", "10.0.1.5"]
hosts = [{{ vms | map(attribute='network.0') | map(attribute='ip') | map('tojson') | join(', ') }}]
command = r"hostnamectl | grep -Fi hostname | sed -Ee 's/^ *(.+)/UP \1/'"

def execute_ssh_command(host, username, password, command):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(hostname=host, username=username, password=password, timeout=5)
        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode().strip()
        error = stderr.read().decode().strip()

        if output:
            print(output)
        if error:
            print(f"Fehler von {host}: {error}")

        client.close()

    except Exception as e:
        print(f"Fehler bei {host}: {e}")


for host in hosts:
    execute_ssh_command(host, username, password, command)


