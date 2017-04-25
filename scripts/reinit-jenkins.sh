#!/bin/bash

THIS=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname ${THIS}`

source ${SCRIPT_DIR}/ENV

${SCRIPT_DIR}/setup-network.sh

JENKINS_HOME=/opt/jenkins/home

docker pull ${JENKINS_IMAGE}

#set -x

systemctl status $JENKINS_SERVICE && systemctl stop $JENKINS_SERVICE

docker ps -a | grep $JENKINS_CONTAINER
RET=$?
if [ $RET == 0 ]; then
    echo "Removing pre-exising jenkins container."
    docker stop $JENKINS_CONTAINER
    docker rm $JENKINS_CONTAINER
fi

docker run -d \
           --name $JENKINS_CONTAINER \
           --net=ci-network \
           --link indy:indy \
           -p 8080:8080 \
           -v /etc/localtime:/etc/localtime:ro \
           -v $JENKINS_HOME:/var/jenkins_home \
           $JENKINS_IMAGE


if [ "$SHOW_LOGS" == "true" ]; then
    docker logs -f $JENKINS_CONTAINER
fi

systemctl start $JENKINS_SERVICE
