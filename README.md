# Docker-SNMPD

[![GitHub issues](https://img.shields.io/github/issues/hbrennhaeuser/docker-snmpd.svg?style=flat-square)](https://github.com/hbrennhaeuser/docker-snmpd/issues) [![GitHub license](https://img.shields.io/github/license/hbrennhaeuser/docker-snmpd.svg?style=flat-square)](https://github.com/hbrennhaeuser/docker-snmpd/blob/master/LICENSE) [![Docker Pulls](https://img.shields.io/docker/pulls/hbrennhaeuser/snmpd.svg?style=flat-square)](https://hub.docker.com/r/hbrennhaeuser/snmpd/)

Docker image to provide snmpd (net-snmp)

## Quickstart

```sh
docker run -d -v /proc:/host_proc:ro \
  --name snmpd \
  -p 10161:10161/udp \
  -v ./snmpd.conf:/etc/snmp/snmpd.conf \
  localhost/docker-snmpd:latest
```
