#!/bin/bash

THIS=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname ${THIS}`

unset SHOW_LOGS
$SCRIPT_DIR/reinit-cleanup.sh
$SCRIPT_DIR/reinit-indy.sh
$SCRIPT_DIR/reinit-jenkins.sh
