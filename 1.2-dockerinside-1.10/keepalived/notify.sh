#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
        "MASTER") echo "status: MASTER" >> /dev/stdout
                  exit 0
                  ;;
        "BACKUP") echo "status: BACKUP" >> /dev/stdout
                  exit 0
                  ;;
        "FAULT")  echo "status: ERROR" >> /dev/stderr
                  exit 0
                  ;;
        *)        echo "status : UNKNOWN" >> /dev/stderr
                  exit 1
                  ;;
esac