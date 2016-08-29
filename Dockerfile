FROM bodsch/docker-alpine-base:1609-01

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.0.1"

ENV TERM xterm

EXPOSE 80

# ---------------------------------------------------------------------------------------

RUN \
  apk --quiet --no-cache update && \
  apk --quiet --no-cache add \
    bash \
    nginx && \
  mkdir -p \
    /run/nginx \
    /var/cache/nginx/body \
    /var/cache/nginx/proxy && \
  chown -R nginx:nginx /var/cache/nginx && \
  rm -rf /var/cache/apk/*

ADD rootfs/ /

WORKDIR '/etc/nginx'

CMD [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------
