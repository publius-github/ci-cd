#!/bin/bash

cd /etc/ecosystem

while [ ! -e /var/run/docker.sock ] ; do
  inotifywait -t 2 -e create /var/run
done
if [ -f /etc/default/ecosystem ]; then
  . /etc/default/ecosystem
fi
. ${PWD}/env.sh
/usr/local/bin/docker-compose kill
/usr/local/bin/docker-compose rm -f
dead_containers=$(docker ps -aqf status=dead)
if [ -n "$dead_containers" ]; then
  docker rm -f $dead_containers >/dev/null 2>&1 || true
fi

$(aws ecr get-login --region us-east-1 --no-include-email)
