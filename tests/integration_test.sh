#!/bin/bash

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
  echo ""
}


send_request() {

  echo "send requests"
  echo "- health check"
  curl -I http://localhost/health

  echo "- index.html"
  curl -I http://localhost/index.html
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

