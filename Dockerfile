FROM mcfio/alpine

RUN apk upgrade --update \
  && apk add --no-cache icu-libs murmur

COPY root/ /

EXPOSE 64738/tcp 64738/udp
VOLUME /config
