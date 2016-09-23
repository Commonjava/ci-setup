#!/bin/bash

export DOCKER_HOST="tcp://$(ip route show | grep default | awk '{print $3}'):2375"

