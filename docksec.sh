#!/bin/bash

# bash script to secure Docker Hosts. 
# Written on an Ubuntu 16.04 LTS Server
# Written by Ted LeRoy with help from Google and the Linux community
# Follow or contribute on GitHub here:
# https://github.com/TedLeRoy/docksec

# Defining Colors for text output
red=$( tput setaf 1 );
yellow=$( tput setaf 3 );
green=$( tput setaf 2 );
normal=$( tput sgr 0 );

# Defining Header
HEADER="
ubuntu-update.sh Copyright (C) 2018 Ted LeRoy
Script to remediate findings of Docker Bench for Security. Harden your Docker host.
This program comes with ABSOLUTELY NO WARRANTY see
https://github.com/TedLeRoy/docksec/blob/master/LICENSE.md
This is free software, and you are welcome to redistribute it
under certain conditions.
See  https://github.com/TedLeRoy/docksec/blob/master/LICENSE.md
for details."

echo
echo "#Setting auditd to monitor docker files
-w /lib/systemd/system/docker.service -k docker
-w /lib/systemd/system/docker.socket -k docker
-w /usr/bin/docker -p rwxa -k docker
-w /var/lib/docker/ -p rwxa -k docker
-w /etc/docker/ -p rwxa -k docker
-w /etc/default/docker -p rwxa -k docker
-w /etc/docker/daemon.json -p rwxa -k do1cker
-w /usr/bin/docker-containerd -p rwxa -k docker
-w /usr/bin/docker-runc -p rwxa -k docker
" >> /etc/audit/audit.rules
echo"
auditd set
"
echo "Restarting auditd service"
service auditd restart
echo "
auditd service restarted
"
echo "Restricting network traffic between containers"
#service docker stop
#dockerd --icc=false
#service docker start
echo "
Network traffic between containers restricted
"
