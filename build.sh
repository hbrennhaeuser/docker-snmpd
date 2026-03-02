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

PLATFORMS=("linux/amd64" "linux/arm64")
BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

for PLATFORM in "${PLATFORMS[@]}"; do
  ARCH="${PLATFORM##*/}"
  TAG="${IMAGE_NAME}:${VERSION}-${ARCH}"

  echo ""
  echo "========== Building $TAG ==========="

  podman build \
    --platform "${PLATFORM}" \
    -t $TAG \
    --build-arg VERSION="${VERSION}" \
    --build-arg NET_SNMP_VERSION="${NET_SNMP_VERSION}" \
    --build-arg BUILD_DATE="${BUILD_DATE}" .
done


echo ""
echo "========== Creating manifest ==========="

podman manifest rm "${IMAGE_NAME}:${VERSION}"
podman manifest create "${IMAGE_NAME}:${VERSION}"

for PLATFORM in "${PLATFORMS[@]}"; do
  ARCH="${PLATFORM##*/}"
  podman manifest add "${IMAGE_NAME}:${VERSION}" "${IMAGE_NAME}:${VERSION}-${ARCH}"
done

podman tag "${IMAGE_NAME}:${VERSION}" "${IMAGE_NAME}:${REF}"