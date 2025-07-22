FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive \
    OCSERV_INSTALL_DIR=/opt/ocserv \
    OCSERV_VERSION=1.3.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential pkg-config libgnutls28-dev libev-dev \
    libreadline-dev libpam0g-dev liblz4-dev libseccomp-dev \
    libnl-route-3-dev libkrb5-dev libradcli-dev libcurl4-gnutls-dev \
    libcjose-dev libjansson-dev liboath-dev libprotobuf-c-dev \
    libtalloc-dev libhttp-parser-dev protobuf-c-compiler gperf \
    iperf3 lcov libuid-wrapper libpam-wrapper libnss-wrapper \
    libsocket-wrapper gss-ntlmssp haproxy iputils-ping freeradius \
    gawk gnutls-bin iproute2 yajl-tools tcpdump ipcalc-ng \
    wget iptables bash ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN mkdir -p "$OCSERV_INSTALL_DIR" && \
    wget ftp://ftp.infradead.org/pub/ocserv/ocserv-${OCSERV_VERSION}.tar.xz && \
    tar xf ocserv-${OCSERV_VERSION}.tar.xz && \
    cd ocserv-${OCSERV_VERSION} && \
    ./configure --prefix="$OCSERV_INSTALL_DIR" && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443/tcp
EXPOSE 443/udp

ENTRYPOINT ["/entrypoint.sh"]