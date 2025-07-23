FROM debian:bullseye-slim AS builder

ARG OCSERV_VERSION=1.3.0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    build-essential pkg-config wget ca-certificates \
    libgnutls28-dev libev-dev libreadline-dev libpam0g-dev liblz4-dev \
    libseccomp-dev libnl-route-3-dev libkrb5-dev libradcli-dev \
    libcurl4-gnutls-dev libcjose-dev libjansson-dev liboath-dev \
    libprotobuf-c-dev libtalloc-dev libhttp-parser-dev protobuf-c-compiler gperf ipcalc-ng && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN mkdir -p /opt/ocserv && \
    wget ftp://ftp.infradead.org/pub/ocserv/ocserv-${OCSERV_VERSION}.tar.xz && \
    tar xf ocserv-${OCSERV_VERSION}.tar.xz && \
    cd ocserv-${OCSERV_VERSION} && \
    ./configure --prefix=/opt/ocserv && \
    make -j"$(nproc)" && \
    make install

FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    libgnutls30 libev4 libpam0g libtalloc2 libradcli4 liboath0 \
    libprotobuf-c1 libgssapi-krb5-2 libk5crypto3 libkrb5-3 \
    libcom-err2 libkeyutils1 libidn2-0 libp11-kit0 libnettle8 \
    libhogweed6 libgmp10 libtasn1-6 libffi7 libcap-ng0 libcrypt1 \
    libunistring2 libaudit1 \
    iproute2 iptables bash && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/ocserv /opt/ocserv
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /etc/ocserv

EXPOSE 443/tcp
EXPOSE 443/udp

ENTRYPOINT ["/entrypoint.sh"]
