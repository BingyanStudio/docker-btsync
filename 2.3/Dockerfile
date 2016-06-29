FROM alpine:3.3

ENV BTSYNC_VERSION 2.3.8

RUN deps='curl ca-certificates' && \
    apk --no-cache add $deps && \
    # install glibc
    cd /tmp && \
       wget -q -O /etc/apk/keys/sgerrand.rsa.pub \
            https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
       wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && \
       apk add glibc-2.23-r3.apk && \
       # install btsync
       curl -sSL -o archive.tgz https://download-cdn.getsync.com/2.3.8/linux-x64/BitTorrent-Sync_x64.tar.gz && \
       tar -xvpzf archive.tgz && \
       mv btsync /usr/local/bin && \
    # cleanup
    cd / && rm -rf /tmp/* && \
    apk del $deps

ENV DEVICE Alpine_x64_docker
ENV USE_UPNP false
ENV LISTENING_PORT 34567
ENV WEBUI_PORT 8888

ENV LOGIN=
ENV PASSWORD=
ENV PASSWORD_HASH=

ENV FORCE_HTTPS false
ENV SSL_CERT /etc/btsync/cert.pem
ENV SSL_KEY /etc/btsync/private.key

ENV DIRECTORY_ROOT /data
ENV UID 1000
ENV GID 1000

EXPOSE $LISTENING_PORT $LISTENING_PORT/udp $WEBUI_PORT

VOLUME $DIRECTORY_ROOT
WORKDIR $DIRECTORY_ROOT

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["btsync", "--nodaemon", "--config", "/etc/btsync.conf"]
