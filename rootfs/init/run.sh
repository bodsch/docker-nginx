#!/bin/sh

[ -d /var/log/nginx ] || mkdir -vp /var/log/nginx

[ -f /etc/nginx/conf.d/default.conf ] && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf-DISABLED

for f in /etc/nginx/external/*.conf
do
  cp -a ${f} /etc/nginx/conf.d/ 2> /dev/null > /dev/null
done

exec "$@"
