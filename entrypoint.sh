#!/usr/bin/env sh
set -eu

if ! grep -qE '[[:space:]]/host_proc[[:space:]]' /proc/self/mountinfo; then
	echo "ERROR: /host_proc is not mounted. Start container with: -v /proc:/host_proc:ro" >&2
	sleep infinity
fi

exec /usr/local/sbin/snmpd -f -c /etc/snmp/snmpd.conf
