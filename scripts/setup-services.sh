#!/bin/bash

THIS=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname ${THIS}`

source ${SCRIPT_DIR}/ENV

set -x

for s in $(cd ${SCRIPT_DIR}/services && ls -1 *.service); do
	echo "Setting up ${s}..."
	systemctl list-units | grep $s > /dev/null
	RET=$?

	if [ $RET != 0 ]; then
		echo "${s} is not in systemd/system...copying it."
		cp $SCRIPT_DIR/services/$s /etc/systemd/system
	fi
done

systemctl daemon-reload
for s in $(cd ${SCRIPT_DIR}/services && ls -1 *.service); do
	echo "Enabling ${s}"
	systemctl enable $s
done
