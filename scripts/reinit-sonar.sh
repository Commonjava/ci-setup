#!/bin/bash

THIS=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname ${THIS}`

source ${SCRIPT_DIR}/ENV

${SCRIPT_DIR}/setup-network.sh

docker pull ${SONAR_IMAGE}

#set -x

systemctl status $SONAR_SERVICE && systemctl stop $SONAR_SERVICE

docker ps -a | grep $SONAR_CONTAINER
RET=$?
if [ $RET == 0 ]; then
    echo "Removing pre-exising sonar container."
    docker stop $SONAR_CONTAINER
    docker rm $SONAR_CONTAINER
fi

docker run -d \
    --name sonar \
    -p 9000:9000 \
    -p 9092:9092 \
    --link sonardb:sonardb \
    --net=ci-network \
    -e SONARQUBE_JDBC_USERNAME=sonar \
    -e SONARQUBE_JDBC_PASSWORD=sonar \
    -e SONARQUBE_JDBC_URL=jdbc:postgresql://sonardb/sonar \
    $SONAR_IMAGE

if [ "$SHOW_LOGS" == "true" ]; then
    docker logs -f $SONAR_CONTAINER
fi

systemctl start $SONAR_SERVICE
