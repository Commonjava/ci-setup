#!/bin/bash

THIS=$(cd ${0%/*} && echo $PWD/${0##*/})
BASEDIR=`dirname ${THIS}`
BASEDIR=`dirname ${BASEDIR}`
IMAGE_DIR=${BASEDIR}/image

JENKINS_HOME=/opt/jenkins/home

docker pull jenkins
docker build --tag=ci-jenkins $IMAGE_DIR
RET=$?

if [ $RET != 0 ]; then
    echo "Docker build failed. Exiting."
    exit 1
fi

set -x

docker ps -a | grep jenkins
RET=$?
if [ $RET == 0 ]; then
    echo "Removing pre-exising jenkins container."
    docker stop jenkins
    docker rm jenkins
fi

docker run -d \
           --name jenkins \
           --net=ci-network \
           --privileged \
           -p 8080:8080 \
           -v /etc/localtime:/etc/localtime:ro \
           -v $JENKINS_HOME:/var/jenkins_home \
           ci-jenkins


docker logs -f jenkins
