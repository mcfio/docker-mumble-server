FROM alpine:latest

ENV MURMUR_VERSION=1.2.19

LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.name="mcf.io Mumble Server" \
  org.label-schema.build="" \
  org.label-schema.url="https://wiki.mumble.info/wiki/Main_Page" \
  org.label-schema.vcs-url="https://github.com/mcfio/docker-mumble-server" \
  org.label-schema.vendor="mcf.io" \
  org.label-schema.version="${MURMUR_VERSION}" \
  org.label-schema.docker.cmd="docker run -d -p 64738:64738 -p 64738:64738/udp -v <data dir>:/data mcfio/mumble-server"

WORKDIR /etc/murmur

ADD https://github.com/mumble-voip/mumble/releases/download/${MURMUR_VERSION}/murmur-static_x86-${MURMUR_VERSION}.tar.bz2 /tmp

RUN apk upgrade --update-cache

RUN apk add \
    pwgen \
    libressl \
  && addgroup -S murmur \
  && adduser -SDH murmur -G murmur \
  && mkdir \
    /data \
    /opt \
    /var/run/murmur \
  && chown -R murmur:murmur \
    /var/run/murmur \
    /etc/murmur \
  && tar -x -j -C /opt -f /tmp/murmur-static_x86-${MURMUR_VERSION}.tar.bz2 \
  && mv /opt/murmur* /opt/murmur \
  && rm -rf \
    /var/cache/apk/* \
    /tmp/*

COPY config/ /etc/murmur
COPY docker-entrypoint.sh /usr/local/bin

EXPOSE 64738/tcp 64738/udp

VOLUME ["/data"]

ENTRYPOINT ["docker-entrypoint.sh"]
