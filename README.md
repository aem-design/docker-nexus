## CentOS 7 with Nexus

[![build_status](https://travis-ci.org/aem-design/docker-nexus.svg?branch=master)](https://travis-ci.org/aem-design/docker-nexus) 
[![github license](https://img.shields.io/github/license/aem-design/nexus)](https://github.com/aem-design/nexus) 
[![github issues](https://img.shields.io/github/issues/aem-design/nexus)](https://github.com/aem-design/nexus) 
[![github last commit](https://img.shields.io/github/last-commit/aem-design/nexus)](https://github.com/aem-design/nexus) 
[![github repo size](https://img.shields.io/github/repo-size/aem-design/nexus)](https://github.com/aem-design/nexus) 
[![docker stars](https://img.shields.io/docker/stars/aemdesign/nexus)](https://hub.docker.com/r/aemdesign/nexus) 
[![docker pulls](https://img.shields.io/docker/pulls/aemdesign/nexus)](https://hub.docker.com/r/aemdesign/nexus) 
[![github release](https://img.shields.io/github/release/aem-design/nexus)](https://github.com/aem-design/nexus)

This is docker image based on [aemdesign/oracle-jdk](https://hub.docker.com/r/aemdesign/oracle-jdk/) with Nexus added

### Included Packages

Following is the list of packages included

* nexus                 - for storing artifacts

### Starting

To start local Nexus instance on port 8081

```bash
docker run --name nexus \
-p8081:8080 -d \
aemdesign/nexus:latest
``` 