#!/bin/bash

THIS=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname ${THIS}`

source ${SCRIPT_DIR}/ENV

${SCRIPT_DIR}/setup-network.sh

docker pull ${INDY_IMAGE}

#set -x

systemctl status $INDY_SERVICE && systemctl stop $INDY_SERVICE

docker ps -a | grep $INDY_CONTAINER
RET=$?
if [ $RET == 0 ]; then
    echo "Removing pre-exising jenkins container."
    docker stop $INDY_CONTAINER
    docker rm $INDY_CONTAINER
fi

GIT_URL=$(git remote show origin | grep Fetch | awk '{print $3}' | sed -e 's|git@github.com:|https://github.com/|g')
docker run -d \
           --name $INDY_CONTAINER \
           --net=ci-network \
           -e INDY_ETC_URL=$GIT_UTL \
           -e INDY_ETC_SUBPATH=indy/etc \
           -p 8180:8180 \
           $INDY_IMAGE


if [ $SHOW_LOGS == true ]; then
    docker logs -f $INDY_CONTAINER
fi

systemctl start $INDY_SERVICE
