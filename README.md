# docksec
Script to remediate findings of Docker Bench for Security. Harden your Docker host.

In its present form, the script will harden an Ubuntu 16.04 Docker Host so that it complies with the majority of the Center for Internet Security (CIS) Benchmarks for Docker Community Edition (CE). 

It should work on any Linux based Docker host, but has only been tested on Ubuntu 16.04 to date.

The steps needed to harden the Docker Host were derived from running a scan using the [Docker Bench for Security](https://github.com/docker/docker-bench-security) script avialable on [GitHub](https://github.com/docker/docker-bench-security).

This project is [licensed](https://github.com/TedLeRoy/docksec/blob/master/LICENSE) under GPLv3, and is available on [GitHub](https://github.com/TedLeRoy/docksec).

## Background

Several steps are required to take a default installation of Ubuntu 16.04, install Docker, then make it compliant with the CIS Benchmarks. 

Hardening guidelines are from the CIS Benchmark for Docker Community Edition, version 1.1.0-07-06-2017.

CIS Benchmarks are available for free after you [register](https://www.cisecurity.org/cis-benchmarks/). You'll have to browse to the files you're after when you receive the link to download in your email.

Since securing the Docker host is a repetitive task many people will ostensibly want to do, I'm scripting it and making it available to the community to use and for review and input about features that will make it more useful.

## [Project Goal](#project-goal)

This project's goal is to allow the administrator of a Linux based Docker server to run a single script which will result in a configuration that fulfills the CIS Benchmarks for Docker CE.

Settings beyond the control of the script, such as creating a separate partition for use by containers will be called out for the user to address.

## Who This Is For

docksec.sh is for administrators who want to create a consistent, secure environment to run their Docker containers from. 

A suggested use case is to run the script, check that it has secured the Docker host to the desired level by running [Docker Bench for Security](https://github.com/docker/docker-bench-security) against it, then using the hardened Docker host as a template for future implementations.

## What It Does

docksec.sh will do the following for you:

* Check for auditd, and install it if it is not already present.
* Configure auditing.
  * It will add lines to `/etc/audit/audit.rules` to do this.
  * It will restart the auditd service to make the changes take effect.
* Add an entry to `/etc/default/docker` telling it to check the `/etc/docker/daemon.json` file for configuration settings.
* Create or populate the `/etc/docker/daemon.json` file with entries that will do the following:
  * Disable Inter Container Communications (icc) over the default bridge.
  * Disable Legacy Registries
  * Enable Live Restore
  * Disable Userland Proxy
  * Disable New Privileges for Containers
* Restart the Docker service to make changes take effect.

The script makes a backup of any files touched in the process, but it is crude at present and may clobber your backups if you use the same naming convention used by teh script, or if you run the script multiple times.

As additional functionality is added, it will show up here.

## Prerequisites

You must have sudo permission to run this script and it must be run as root or with sudo permission.

You must understand your Docker environment and the implications of running this script on your environment.

You must be prepared to troubleshoot any issues that arise from running the script.

Everything the script does is available to you in the docksec.sh file, so you can refer to that should troubleshooting be necessary.

## Installing

This project is under active development until it has the functionality I'm after, so the preferred method of running it is to create a local clone of the git repository.

```
sudo apt install git
cd ~/my_projects
git init
git clone https://github.com/TedLeRoy/docksec.git
```

When you want to get the latest code, just get into the docksec directory and run `git pull`.

```
cd ~/my_projects/docksec
git pull
```

This will download the latest version.

## Usage

It is recommended that all containers be stopped prior to running the script as several services are restarted and reconfigured as the script is processed.

To run the script, just be in the directory where `docksec.sh` resides and run it.

```
cd ~my_projects/docksec
sudo ./docksec.sh
```

## Scan With Docker Bench For Security

After running `docksec.sh`, make sure the system is secured to your liking by scanning with [Docker Bench for Security](https://github.com/docker/docker-bench-security).

```
cd ~/my_projects
git clone https://github.com/docker/docker-bench-security.git
cd docker-bench-security
sudo ./docker-bench-security.sh
```

Observe the output, looking for Warnings \[WARN\] and address any found that you deem to need fixing.

I usually capture the warnings by grepping for them at run time.

```
sudo ./docker-bench-security.sh | grep WARN
```

You can still find the full history of each run of docker-bench-security.sh at `~/my_projects/docker-bench-security/docker-bench-security.log` if you want to see the full output, or see how it changes over time.

## Updates

If you installed a git clone using the steps above, just do a `git pull` to update to the latest version.

```
cd ~/my_projects/docksec
git pull
```

## Author

* **Ted LeRoy** - *Initial Work* - docksec.sh 

## License

This project is licensed under the GNU General Public License - see the [LICENSE.md](https://github.com/TedLeRoy/docksec/blob/master/LICENSE) file for details.

## Acknowledgements

* The creators and maintainers of [Docker Bench for Security](https://github.com/docker/docker-bench-security/blob/master/MAINTAINERS), [diogomonica](https://github.com/diogomonica), and [konstruktoid](https://github.com/konstruktoid).
* The creators and maintainers of [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/), and the Docker CE Benchmark.
  * Author: Pravin Goyal
  * Editors: Thomas Sjogren, Rory McCune, NCC Group PLC
  * Contributors: Brian Andrzejewski, Jordan Rakoske, GSEC, GCWN

## Built With

bash on Ubuntu 16.04.4 LTS Server running Docker 18.03.0-ce.

## Future Goals

* Run all checks, not just those indicated for a default Ubuntu/Docker install.
  * Only do needed checks, but don't skip steps, assuming they're already configured by default.
* Accept a Docker Bench for Security log as input and secure based on that.
* Improve efficiency in the code. 
  * For example, use config settings as input to a variable and iterate through the variable for checks and to update config.
* Check for existence of backupfiles and create a rotation if new backups if files exist already.

## Run Results

Here's a screenshot of the WARNING level findings of a run of Docker Bench for Security on an Ubuntu 16.04.4 LTS Server running Docker version 18.03.0-ce prior to using docksec.sh:

![Pre-docksec.sh](https://image.ibb.co/gPH8bc/docksec_pre_script.png)

Here's a screenshot of the WARNING level findings after running docksec.sh:

![post-docsec.sh](https://image.ibb.co/cGWO9x/docker_post_new_script.png)

Quite a reduction in findings, but I will be making it all green, and seeing how it impacts the environment and will tweak accordingly.

If having all green findings result in a very difficult to use environment, I'll be adding options to let the user choose the security level you desire.
