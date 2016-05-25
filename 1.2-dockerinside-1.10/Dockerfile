FROM debian:jessie
MAINTAINER Nicolas Berthe <nicolas.berthe@alterway.fr>

ENV KEEPALIVED_VERSION 1:1.2.13-1
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y keepalived=${KEEPALIVED_VERSION} && \
    rm -rf /var/lib/apt/lists/*

ENV DOCKER_VERSION 1.10.3
ADD https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION} /usr/bin/docker
RUN chmod +x /usr/bin/docker

COPY keepalived /etc/keepalived/
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
