
FROM alpine:3.6

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

ENV \
  ALPINE_MIRROR="mirror1.hs-esslingen.de/pub/Mirrors" \
  ALPINE_VERSION="v3.6" \
  TERM=xterm \
  BUILD_DATE="2017-11-13" \
  NGINX_VERSION="1.12.2"

EXPOSE 80 443

LABEL \
  version="1711" \
  org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.name="NginX Docker Image" \
  org.label-schema.description="Inofficial NginX Docker Image" \
  org.label-schema.url="https://nginx.org" \
  org.label-schema.vcs-url="https://github.com/bodsch/docker-nginx" \
  org.label-schema.vendor="Bodo Schulz" \
  org.label-schema.version=${NGINX_VERSION} \
  org.label-schema.schema-version="1.0" \
  com.microscaling.docker.dockerfile="/Dockerfile" \
  com.microscaling.license="GNU General Public License v3.0"

# ---------------------------------------------------------------------------------------

#RUN \
#  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/main"       > /etc/apk/repositories && \
#  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/community" >> /etc/apk/repositories && \

RUN \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    nginx && \
  mkdir -p \
    /etc/nginx/secure \
    /etc/nginx/external \
    /var/log/nginx/ \
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

HEALTHCHECK \
  --interval=5s \
  --timeout=2s \
  --retries=12 \
  CMD curl --silent --fail http://localhost/health || exit 1


ENTRYPOINT [ "/init/run.sh" ]

CMD [ "/usr/sbin/nginx" ]

# ---------------------------------------------------------------------------------------
