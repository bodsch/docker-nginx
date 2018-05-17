#!/bin/sh

create_certificate() {

  [ -d /etc/nginx/secure ] || mkdir /etc/nginx/secure

  DH_SIZE=${DH_SIZE:-2048}
  DH_FILE="/etc/nginx/secure/dh.pem"

  CERT_C="DE"
  CERT_ST="XXXX"
  CERT_L="XXXX"
  CERT_O="self signed"
  CERT_CN=${HOSTNAME}

  HOSTNAME=${HOSTNAME-localhost}

  if [ ! -e "${DH_FILE}" ]
  then
    echo " [i] generating ${DH_FILE} with size: ${DH_SIZE}"
    openssl dhparam -out "${DH_FILE}" ${DH_SIZE}
  fi

  if [ ! -e "/etc/nginx/secure/cert.pem" ] || [ ! -e "/etc/nginx/secure/key.pem" ]
  then
    echo " [i] generating self signed cert"
    openssl \
      req \
      -x509 \
      -newkey \
      rsa:4086 \
      -subj "/C=${CERT_C}/ST=${CERT_ST}/L=${CERT_L}/O=${CERT_O}/CN=${CERT_CN}" \
      -keyout "/etc/nginx/secure/key.pem" \
      -out "/etc/nginx/secure/cert.pem" \
      -days 3650 \
      -nodes \
      -sha256
  fi
}

awk -v ttl=${NGINX_RESOLVER_TTL:-5} 'BEGIN { resolvers=""; } /^nameserver/ { resolvers=resolvers" "$2; } END { print "resolver "resolvers " valid="ttl";"; } ' /etc/resolv.conf > /etc/nginx/conf.d/resolvers.conf

[ -d /var/log/nginx ] || mkdir -vp /var/log/nginx

[ -f /etc/nginx/conf.d/default.conf ] && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf-DISABLED

for f in /etc/nginx/external/*.conf
do
  cp -a ${f} /etc/nginx/conf.d/ 2> /dev/null > /dev/null
done

exec "$@"
