FROM bodsch/docker-alpine-base:1610-01

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.1.1"

ENV TERM xterm

EXPOSE 80 443

# ---------------------------------------------------------------------------------------

RUN \
  apk --quiet --no-cache update && \
  apk --quiet --no-cache upgrade && \
  apk --quiet --no-cache add \
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

VOLUME [ "/etc/nginx" ]

WORKDIR "/etc/nginx"

CMD [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------
