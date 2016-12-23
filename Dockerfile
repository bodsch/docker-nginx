
FROM bodsch/docker-alpine-base:1612-01

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.1.3"

ENV TERM xterm

EXPOSE 80 443

# ---------------------------------------------------------------------------------------

RUN \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    nginx && \
  mkdir -p \
    /run/nginx \
    /var/cache/nginx/body \
    /var/cache/nginx/proxy && \
  chown -R nginx:nginx /var/cache/nginx && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

WORKDIR "/etc/nginx"

CMD /opt/startup.sh

# ---------------------------------------------------------------------------------------
