#!/bin/bash

THIS=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname ${THIS}`

source ${SCRIPT_DIR}/ENV

${SCRIPT_DIR}/setup-network.sh

docker pull ${SONAR_DB_IMAGE}

#set -x

systemctl status $SONAR_DB_SERVICE && systemctl stop $SONAR_DB_SERVICE

docker ps -a | grep $SONAR_DB_CONTAINER
RET=$?
if [ $RET == 0 ]; then
    echo "Removing pre-exising sonar container."
    docker stop $SONAR_DB_CONTAINER
    docker rm $SONAR_DB_CONTAINER
fi

docker run -d \
    --name sonardb \
    --net=ci-network \
    -e POSTGRES_USER=sonar \
    -e POSTGRES_PASSWORD=sonar \
    -e POSTGRES_DB=sonar \
    $SONAR_DB_IMAGE

if [ "$SHOW_LOGS" == "true" ]; then
    docker logs -f $SONAR_DB_CONTAINER
fi

systemctl start $SONAR_DB_SERVICE
