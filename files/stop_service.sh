#!/bin/bash

/usr/local/bin/docker-compose stop -t2
/usr/local/bin/docker-compose rm -f
dead_containers=$(docker ps -aqf status=dead)
if [ -n "$dead_containers" ]; then
  docker rm -f $dead_containers >/dev/null 2>&1 || true
fi
