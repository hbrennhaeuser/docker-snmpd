FROM debian:bookworm-slim as builder

ARG NET_SNMP_VERSION

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  linux-libc-dev \
  build-essential \
  curl \
  perl \
  libperl-dev \
  file \
  findutils \
  sed \
  ca-certificates

RUN mkdir -p /etc/snmp && \
  curl -L "https://sourceforge.net/projects/net-snmp/files/net-snmp/${NET_SNMP_VERSION}/net-snmp-${NET_SNMP_VERSION}.tar.gz/download" -o net-snmp.tgz && \
  tar zxvf net-snmp.tgz && \
  cd net-snmp-* && \
  find . -type f -print0 | xargs -0 sed -i 's/\"\/proc/\"\/host_proc/g' && \
  ./configure --prefix=/usr/local --disable-ipv6 --disable-snmpv1 --with-defaults && \
  make && \
  make install DESTDIR=/build



FROM debian:bookworm-slim

ARG BUILD_DATE
ARG VERSION

LABEL org.opencontainers.image.title="docker-snmp" \
  org.opencontainers.image.description="Provides snmpd for CoreOS and other small footprint environments without package managers" \
  org.opencontainers.image.authors="Hannes Brennhaeuser <contact@hbrennhaeuser.de>" \
  org.opencontainers.image.source="https://github.com/hbrennhaeuser/docker-snmp" \
  org.opencontainers.image.version=${VERSION} \
  org.opencontainers.image.created=${BUILD_DATE} 

EXPOSE 161 161/udp

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  perl && \
  rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/usr/local /usr/local

COPY snmpd.conf /etc/snmp

CMD [ "/usr/local/sbin/snmpd", "-f", "-c", "/etc/snmp/snmpd.conf" ]
