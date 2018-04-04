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

# Define CIS Benchmark Version Number
BENCHMARK="v1.1.0-07-06-2017"

# Defining Header

HEADER="${red}
ubuntu-update.sh Copyright (C) 2018 Ted LeRoy
Script to remediate findings of Docker Bench for Security. Harden your Docker host.
This program comes with ABSOLUTELY NO WARRANTY see
https://github.com/TedLeRoy/docksec/blob/master/LICENSE.md
This is free software, and you are welcome to redistribute it
under certain conditions.
See  https://github.com/TedLeRoy/docksec/blob/master/LICENSE.md
for details.${normal}
"

# Checkng whether running as root and exiting if not.

if [[ ${UID} != 0 ]]; then
    echo "${red}
    This script must be run as root or with sudo permissions.
    Please run using sudo.${normal}
    "
    exit 1
fi

# Print header

echo "$HEADER"

# Print CIS Benchmark Version information
echo "${green}Standards for this hardening script are 
based on the CIS Docker Comunity Edition Benchmark $BENCHMARK.${normal}"

# Checking whether auditd is installed, and installing if not.

PKGNAME="auditd"

command -v $PKGNAME

INSTALLED="${?}"

if [[ "$INSTALLED" -eq 0 ]]
then
  echo
  echo "${green}$PKGNAME is already installed. Proceeding.${normal}"
else
  echo "Installing $PKGNAME."
  apt-get install $PKGNAME -y
  echo "$PKGNAME installed.
"
fi

# Configure auditing for Docker directories, files, and services.
# See CIS Benchmark 1.5 to 1.13

echo
echo "# Setting auditd to monitor docker files
# Refer to findings 1.5 to 1.13
-w /lib/systemd/system/docker.service -k docker
-w /lib/systemd/system/docker.socket -k docker
-w /usr/bin/docker -p rwxa -k docker
-w /var/lib/docker/ -p rwxa -k docker
-w /etc/docker/ -p rwxa -k docker
-w /etc/default/docker -p rwxa -k docker
-w /etc/docker/daemon.json -p rwxa -k docker
-w /usr/bin/docker-containerd -p rwxa -k docker
-w /usr/bin/docker-runc -p rwxa -k docker
" >> /etc/audit/audit.rules
echo "auditd set
"
echo "Restarting auditd service
"
service auditd restart

echo "${green}auditd service restarted.${normal}
"

# Setting networking to disallow inter-container network communication.
# See CIS Benchmark 2.1 for Impact
# Commenting out as restarting docker presently generates errors

#echo "${red}Restricting network traffic between containers.${normal}
#"
#service docker stop
#dockerd --icc=false
#service docker start

#echo "${red}Network traffic between containers restricted.${normal}
#"
echo


