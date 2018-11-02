FROM buildpack-deps

ENV TINI_VERSION v0.18.0
ENV GOSU_VERSION 1.11

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    wget https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -O /tini && \
    chmod +x /tini && \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
    chmod +x /usr/local/bin/gosu && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/tini", "--"]
ADD "docker-entrypoint.sh" "/docker-entrypoint.sh"
ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]
