FROM bodsch/docker-alpine-base:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.0.0"

ENV TERM xterm

EXPOSE 80

# ---------------------------------------------------------------------------------------

RUN \
  apk --quiet --no-cache update && \
  apk --quiet --no-cache add \
    bash \
    nginx && \
  mkdir /run/nginx && \
  rm -rf /var/cache/apk/*

ADD rootfs/ /

## VOLUME  ["/etc/nginx" ]

WORKDIR '/etc/nginx'

# Initialize and run Supervisor
ENTRYPOINT [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------
