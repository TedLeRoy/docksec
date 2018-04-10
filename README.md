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

