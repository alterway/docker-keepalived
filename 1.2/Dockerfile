FROM debian:jessie
MAINTAINER Nicolas Berthe <nicolas.berthe@alterway.fr>

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y keepalived && \
    rm -rf /var/lib/apt/lists/*

COPY keepalived /etc/keepalived/
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
