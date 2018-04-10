# docksec
Script to remediate findings of Docker Bench for Security. Harden your Docker host.

In its present form, the script will harden an Ubuntu 16.04 Docker Host so that it complies with the majority of the Center for Internet Security (CIS) Benchmarks for Docker Community Edition (CE). 

It should work on any Linux based Docker host, but has only been tested on Ubuntu 16.04 to date.

The steps needed to harden the Docker Host were derived from the [Docker Bench for Security](https://github.com/docker/docker-bench-security) project on [GitHub](https://github.com/docker/docker-bench-security).

This project is [licensed](https://github.com/TedLeRoy/docksec/blob/master/LICENSE) under GPLv3, and is available on [GitHub](https://github.com/TedLeRoy/docksec).

## Background

Several steps are required to take a default installation of Ubuntu 16.04, install Docker, then make it compliant with the CIS Benchmarks. 

Hardening guidelines are from the CIS Benchmark for Docker Community Edition, version 1.1.0-07-06-2017.

CIS Benchmarks are available for free after you [register](https://www.cisecurity.org/cis-benchmarks/). You'll have to browse to the files you're after when you receive the link to download in your email.

Since this is a repetitive task many people will ostensibly want to do, I'm scripting it and making it available to the community for review and input about features that will make it most useful.

## [Project Goals](#project-goals)

This project's goal is to allow the administrator of a Linux based Docker server to run a single script which will result in a configuration that fulfills the CIS Benchmarks for Docker CE.

Settings beyond the control of the script, such as creating a separate partition for use by containers will be called out for the user to address.

## Who This Is For

docksec.sh is for administrators who want to create a consistent, secure environment to run their Docker containers from. A suggested use case is to run the script, check that it has secured the Docker host to the desired level by running [Docker Bench for Security](https://github.com/docker/docker-bench-security) against it, then using the hardened Docker host as a template for future implementations.

## What It Does

docksec.sh will do the following for you:

* Check for auditd, and install it if it is not already present.
* Configure auditing.
  * It will add lines to /etc/audit/audit.rules to do this.
  * It will restart the auditd service to make the changes take effect.
* Add an entry to /etc/default/docker telling it to check the /etc/docker/daemon.json file for configuration settings.
* Disable Inter Container Communications (icc) over the default bridge.
* Disable Legacy Registries
* Enable Live Restore
* Disable Userland Proxy
* Disable New Privileges for Containers
* Restart the Docker service to make changes take effect.

