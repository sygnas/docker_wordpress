#!/bin/bash
. .env
docker exec -it ${CONTAINER_PREFIX}_wp sh -c "/docker-entrypoint-initdb.d/wp-install.sh"
