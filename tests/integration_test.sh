#!/bin/bash

#pushd $PWD
#
#cd $(dirname $(readlink -f "$0"))
#
#if [[ -f ../.env ]]
#then
#  . ../.env
#else
#  echo "run 'make compose-file' first"
#  exit 1
#fi

wait_for_service() {

  echo -e "\nwait for the nginx service"

  RETRY=35
  # wait for the running certificate service
  #
  until [[ ${RETRY} -le 0 ]]
  do
    timeout 1 bash -c "cat < /dev/null > /dev/tcp/localhost/80" 2> /dev/null
    if [ $? -eq 0 ]
    then
      break
    else
      sleep 10s
      RETRY=$(expr ${RETRY} - 1)
    fi
  done

  if [[ $RETRY -le 0 ]]
  then
    echo "Could not connect to the nginx service"
    exit 1
  fi
}


send_request() {

  curl -I     http://localhost/
}


inspect() {

  echo ""
  echo "inspect needed containers"
  for d in $(docker ps | tail -n +2 | awk  '{print($1)}')
  do
    # docker inspect --format "{{lower .Name}}" ${d}
    c=$(docker inspect --format '{{with .State}} {{$.Name}} has pid {{.Pid}} {{end}}' ${d})
    s=$(docker inspect --format '{{json .State.Health }}' ${d} | jq --raw-output .Status)

    printf "%-40s - %s\n"  "${c}" "${s}"
  done
}

inspect
wait_for_service
send_request

exit 0

