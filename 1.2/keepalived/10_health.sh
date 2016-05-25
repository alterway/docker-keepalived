#!/bin/bash

containers="${CONTAINERS_TO_CHECK}"
check_creation=${CHECK_CREATION:-false}

set_swarm_env() {

        export DOCKER_CERT_PATH=${SWARM_CERTS:-/root/.docker/}
        export DOCKER_HOST="tcp://${SWARM_ADDR:-127.0.0.1:4000}"
        export DOCKER_TLS_VERIFY=true
}

check_create() {
   if \$check_creation; then
    {

	set_swarm_env
	CREATION=\$(docker run -d ${CHECK_HEALTH_IMAGE:-cirros} ping 127.0.0.1 -c5  2>&1 1>&2)
	
	 case "\$CREATION" in
          *Error*) exit 1 ;;
          *Cannot*) exit 1 ;;
          *)       echo "\$CREATION" ;;
        esac

	STATE=\$(docker inspect -f {{.State.Running}} \$CREATION)
	
	echo "checking \$CREATION creation ... OK ? :" \$STATE
	docker stop \$CREATION #>/dev/null
	docker rm -f \$CREATION #>/dev/null
	exit 0
   }	
	
   else 
   { 
     exit 0 
   }
   fi
}

check_state() {

	for i in \$containers
	do

	RUNNING=\$(docker inspect --format="{{ .State.Running }}" \$i 2> /dev/null)

	if [ \$? -eq 1 ]; then
  	echo "UNKNOWN - \$i does not exist."
	exit 3
	fi

	if [ "\$RUNNING" = "false" ]; then
	echo "CRITICAL - \$i is not running."
  	exit 2
	fi

	if [ "\$RUNNING" = "true" ]; then
  	echo "OK - \$i is running."
	fi

	done
	check_create
}

check_state
