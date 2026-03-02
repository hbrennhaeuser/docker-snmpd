# Docker-SNMPD

[![GitHub issues](https://img.shields.io/github/issues/hbrennhaeuser/docker-snmpd.svg?style=flat-square)](https://github.com/hbrennhaeuser/docker-snmpd/issues) [![GitHub license](https://img.shields.io/github/license/hbrennhaeuser/docker-snmpd.svg?style=flat-square)](https://github.com/hbrennhaeuser/docker-snmpd/blob/master/LICENSE) [![Docker Pulls](https://img.shields.io/docker/pulls/hbrennhaeuser/snmpd.svg?style=flat-square)](https://hub.docker.com/r/hbrennhaeuser/snmpd/)

A rootless container image for [Net-SNMP](http://www.net-snmp.org/) (`snmpd`).

## Quickstart

```sh
docker run -d \
  --name snmpd \
  -p 161:10161/udp \
  -v /proc:/host_proc:ro \
  ghcr.io/hbrennhaeuser/docker-snmpd:latest
```


## Configuration

Configuration is applied at container startup by assembling a runtime `snmpd.conf` from environment variables. Optionally, a base config file can be mounted.

> **Note:** There is no default configuration. Without a mounted config file or environment variables, `snmpd` will be unconfigured.

### Environment Variables

| Variable | Description |
| :--- | :--- |
| `SNMPD_<PARAM>` | Sets a named `snmpd.conf` directive. The `SNMPD_` prefix is stripped and the key is lowercased. If a base config is mounted, any existing matching directive is commented out. Example: `SNMPD_SYSLOCATION=DC1` → `syslocation DC1` |
| `SNMPD_CUST_<ID>` | Appends a raw verbatim line to the end of the config. Entries are sorted by `<ID>` before being written. Example: `SNMPD_CUST_10="rocommunity public"` |
| `DEBUG` | Set to `true` to enable debug to console stderr. |

### Volumes

| Mount | Required | Description |
| :--- | :--- | :--- |
| `/proc:/host_proc:ro` | **Yes** | Required for `snmpd` to expose host system metrics. |
| `/etc/snmp/snmpd.conf` | No | Base configuration file. Directives set via `SNMPD_<PARAM>` variables take precedence and will override matching entries. |

## Ports

The internal `agentaddress` is fixed to `udp:0.0.0.0:10161,tcp:0.0.0.0:10161` and cannot be changed via environment variables. Map it to the host as needed:

```sh
-p 161:10161/udp
```

## Security

The container runs rootless as a dedicated `snmpd` user (`UID 10001 / GID 10001`).