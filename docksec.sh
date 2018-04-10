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

Script to remediate findings of Docker Bench for Security. 
Harden your Docker host.

This program comes with ABSOLUTELY NO WARRANTY see
https://github.com/TedLeRoy/docksec/blob/master/LICENSE.md
This is free software, and you are welcome to redistribute it
under certain conditions.

See https://github.com/TedLeRoy/docksec/blob/master/LICENSE.md 
for details.${normal}"

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
echo "
${green}Standards for this hardening script are based on the Center for Internet Security (CIS) Docker Comunity Edition Benchmark $BENCHMARK.${normal}"

# Checking whether auditd is installed, and installing if not.

PKGNAME="auditd"
echo

command -v $PKGNAME > /dev/null

INSTALLED="${?}"

if [[ "$INSTALLED" -eq 0 ]]
then
  echo "${green}$PKGNAME is already installed. Proceeding.${normal}"
else
  echo "${green}Installing $PKGNAME."
  apt-get install $PKGNAME -y
  echo "$PKGNAME installed.${normal}
"
fi

# Configure auditing for Docker directories, files, and services.
# See CIS Benchmark 1.5 to 1.13

echo "
Creating a backup of /etc/audit/audit.rules"
cp /etc/audit/audit.rules /etc/audit/audit.rules.001
echo "
${green}Backup created and it can be found at /etc/audit/audit.rules.001.${normal}"

# Make appropriate auditing entries to audit.rules if they do not exist already.

if ! grep -q  "docker.service" /etc/audit/audit.rules;
then
  echo "# Setting auditd to monitor docker files." >> /etc/audit/audit.rules
  echo "# Refer to CIS Benchmark for Docker CE items 1.5 to 1.13" >> /etc/audit/audit.rules
  echo "-w /lib/systemd/system/docker.service -k docker" >> /etc/audit/audit.rules
fi

if ! grep -q  "docker.socket" /etc/audit/audit.rules;
then
  echo "-w /lib/systemd/system/docker.socket -k docker" >> /etc/audit/audit.rules
fi

if ! grep -q  "/usr/bin/docker" /etc/audit/audit.rules;
then
  echo "-w /usr/bin/docker -p rwxa -k docker" >> /etc/audit/audit.rules
fi

if ! grep -q  "/var/lib/docker" /etc/audit/audit.rules;
then
  echo "-w /var/lib/docker -p rwxa -k docker" >> /etc/audit/audit.rules
fi

if ! grep -q  "/etc/docker" /etc/audit/audit.rules;
then
  echo "-w /etc/docker -p rwxa -k docker" >> /etc/audit/audit.rules
fi

if ! grep -q  "/etc/default/docker" /etc/audit/audit.rules;
then
  echo "-w /etc/default/docker -p rwxa -k docker" >> /etc/audit/audit.rules
fi

if ! grep -q  "/etc/docker/daemon.json" /etc/audit/audit.rules;
then
  echo "-w /etc/docker/daemon.json -k docker" >> /etc/audit/audit.rules
fi

if ! grep -q  "/usr/bin/docker-containerd" /etc/audit/audit.rules;
then
  echo "-w /usr/bin/docker-containerd -p rwxa -k docker" >> /etc/audit/audit.rules
fi

if ! grep -q  "/usr/bin/docker-runc" /etc/audit/audit.rules;
then
  echo "-w /usr/bin/docker-runc -p rwxa -k docker" >> /etc/audit/audit.rules
fi

echo "
${green}auditd set.${normal}"

echo "
Restarting auditd service."

service auditd restart

echo "
${green}auditd service restarted.${normal}"

echo "
Creating a backup of /etc/default/docker."

cp /etc/default/docker /etc/default/docker.001

echo "
${green}Backup created and it can be found at /etc/default/docker.001.${normal}"

# Setting Docker to check daemon.json file if needed

if ! grep -q  "daemon.json" /etc/default/docker;
then
  echo "# Pointing docker to daemon.json file.
DOCKER OPTS=\"--config-file=/etc/docker/daemon.json\"" >> /etc/default/docker
fi

# If /etc/docker/daemon.json file exists, create backup. Else continue and create file.

if [[ -f /etc/docker/daemon.json ]];
then
  echo "
Creating a backup of /etc/docker/daemon.json file"

  cp /etc/docker/daemon.json /etc/docker/daemon.json.001

  echo "
Backup has been created and can be found at /etc/docker/daemon.json.001"
fi

# Adding relevant lines to /etc/docker/daemon.json file if they are not already there.

if ! grep -q  "icc" /etc/docker/daemon.json;
then
  echo "{
\"icc\": false
}" >> /etc/docker/daemon.json
fi

if ! grep -q  "disable-legacy" /etc/docker/daemon.json;
then
  echo "{
\"disable-legacy-registry\": true
}" >> /etc/docker/daemon.json
fi

if ! grep -q  "live-restore" /etc/docker/daemon.json;
then
  echo "{
\"live-restore\": true
}" >> /etc/docker/daemon.json
fi

if ! grep -q  "userland-proxy" /etc/docker/daemon.json;
then
  echo "{
\"userland-proxy\": false
}" >> /etc/docker/daemon.json
fi

if ! grep -q  "no-new-privileges" /etc/docker/daemon.json;
then
  echo "{
\"no-new-privileges\": true
}" >> /etc/docker/daemon.json
fi

# Restart Docker Service

echo "
Restarting docker service."

service docker restart

echo "
${green}Docker service restarted.${normal}
"

exit 0
