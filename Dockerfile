FROM ubuntu:16.04
LABEL maintainer "David Barranco <arp4@protonmail.com>"

ARG factorio_version
ENV VERSION $factorio_version

COPY rootfs /opt/factorio
COPY factorio_headless_x64_$VERSION.tar.xz /tmp/factorio_headless.tar.xz 

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
    xz-utils jq &&\
    tar -xJf /tmp/factorio_headless.tar.xz -C /opt && \ 
    rm /tmp/factorio_headless.tar.xz 

WORKDIR /opt/factorio

EXPOSE 34198/udp 27014/tcp

CMD ["./app_entrypoint.sh"]
