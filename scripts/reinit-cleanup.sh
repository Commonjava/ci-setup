#!/bin/bash

SERVICE=docker-cleanup
CONTAINER=docker-cleanup
IMAGE=tutum/cleanup

systemctl stop $SERVICE

docker stop $CONTAINER
docker rm $CONTAINER

docker run -d \
           --privileged \
           -v /var/run:/var/run:rw \
           -v /var/lib/docker:/var/lib/docker:rw \
           -e IMAGE_CLEAN_INTERVAL=300 \
           -e IMAGE_CLEAN_DELAYED=86400 \
           -e VOLUME_CLEAN_INTERVAL=86400 \
           -e IMAGE_LOCKED="gogs/gogs, \
                            tutum/cleanup, \
                            docker.io/commonjava/indy, \
                            docker.io/commonjava/indy-savant, \
                            centos, \
                            docker.io/buildchimp/gogs-test-appliance, \
                            docker.io/commonjava/gogs-test-appliance, \
                            docker.io/buildchimp/git-clone-test, \
                            docker.io/commonjava/git-clone-test, \
                            docker.io/buildchimp/keycloak-test-appliance, \
                            docker.io/commonjava/keycloak-test-appliance, \
                            buildchimp/koji-dojo-hub, \
                            library/postgres" \
           --name=$CONTAINER \
           $IMAGE

systemctl start $SERVICE

