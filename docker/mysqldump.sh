#!/bin/bash
. .env
docker exec -it ${CONTAINER_PREFIX}_db sh -c \
"mysqldump wordpress -u ${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} 2> /dev/null" > ./mysql/${MYSQL_DUMP}