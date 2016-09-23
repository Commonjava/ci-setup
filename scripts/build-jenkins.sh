#!/bin/bash

THIS=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname ${THIS}`

source ${SCRIPT_DIR}/ENV

BASEDIR=`dirname ${SCRIPT_DIR}`
IMAGE_DIR=${BASEDIR}/jenkins/image

JENKINS_HOME=/opt/jenkins/home

docker pull jenkins
docker build --tag=${JENKINS_IMAGE} $IMAGE_DIR
RET=$?

if [ $RET != 0 ]; then
    echo "Docker build failed. Exiting."
    exit 1
fi

docker push ${JENKINS_IMAGE}
