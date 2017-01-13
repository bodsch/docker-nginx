#!/bin/sh
#
#
#

startSupervisor() {

#  /usr/sbin/nginx

  if [ -f /etc/supervisord.conf ]
  then
    /usr/bin/supervisord -c /etc/supervisord.conf >> /dev/null
  else
    exec /bin/sh
  fi
}

startSupervisor

# EOF
