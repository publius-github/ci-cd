#!/bin/bash

cd /etc/ecosystem

if [ -f /etc/default/ecosystem ]; then
  . /etc/default/ecosystem
fi
. ${PWD}/env.sh
exec /usr/local/bin/docker-compose up -t2 >> /var/log/ecosystem/ecosystem.log 2>&1
