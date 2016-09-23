#!/bin/bash

docker network ls | grep ci-network >/dev/null
NRET=$?
if [ $NRET != 0 ]; then
    echo "Defining bridged custom network 'ci-network'"
    docker network create -d bridge ci-network
fi

