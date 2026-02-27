#!/bin/bash
set -euo pipefail

if REF="$(git describe --tags --exact-match 2>/dev/null)"; then
  :
else
  REF="$(git rev-parse --abbrev-ref HEAD)"
fi
[[ "${REF}" == "main" || "${REF}" == "master" ]] && REF="latest"

NET_SNMP_VERSION="5.9.4"

IMAGE_NAME="docker-snmpd"
VERSION="${REF}-netsnmp.${NET_SNMP_VERSION}"

PLATFORMS=(
  # "linux/amd64"
  "linux/arm64"
)


for platform in "${PLATFORMS[@]}"; do
  extra_tag_args=()
  [[ "${REF}" == "latest" ]] && extra_tag_args+=( -t "${IMAGE_NAME}:latest" )

  podman build \
    --platform "${platform}" \
    --build-arg VERSION="${VERSION}" \
    --build-arg NET_SNMP_VERSION="${NET_SNMP_VERSION}" \
    --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    -t "${IMAGE_NAME}:${VERSION}" \
    "${extra_tag_args[@]}" .
done
