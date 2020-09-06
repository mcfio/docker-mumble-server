FROM alpine:latest

ARG BUILD_DATE
ARG VCS_REF

ENV MURMUR_VERSION=1.2.19

LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.name="mcf.io Mumble Server" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.url="https://wiki.mumble.info/wiki/Main_Page" \
  org.label-schema.vcs-url="https://github.com/mcfio/docker-mumble-server.git" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.vendor="mcf.io" \
  org.label-schema.version="${MURMUR_VERSION}" \
  org.label-schema.docker.cmd="docker run -d -p 64738:64738 -p 64738:64738/udp -v <data dir>:/data mcfio/mumble-server"

WORKDIR /etc/murmur

RUN apk add --no-cache \
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
  && wget \
    https://github.com/mumble-voip/mumble/releases/download/${MURMUR_VERSION}/murmur-static_x86-${MURMUR_VERSION}.tar.bz2 -O - | \
    tar -x -j -C /opt -f - \
  && mv /opt/murmur* /opt/murmur \
  && cp /etc/murmur/murmur.ini /etc/murmur/murmur.ini.bak

COPY config/ /etc/murmur
COPY docker-entrypoint.sh /usr/local/bin

EXPOSE 64738/tcp 64738/udp

VOLUME ["/data"]

ENTRYPOINT ["docker-entrypoint.sh"]
