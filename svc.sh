#!/bin/bash

SVC_NAME="collaborate"
SVC_DESCRIPTION="Prosemirror editor"

SVC_PATH=/etc/systemd/system/${SVC_NAME}.service
BIN_PATH=`pwd`
SVC_CMD=$1

user_id=`id -u`

if [ $user_id -ne 0 ]; then
	echo "Must run as sudo"
	exit 1
fi

function failed()
{
	echo "Failed: ${1}" > 2
	exit 1
}

function install()
{
	cat << HERE > ${SVC_PATH}
[Unit]
Description=Collaborate - A prose mirror editor
Documentation=https://github.com/raydwaipayan/collaborate
After=network.target

[Service]
Environment=NODE_ENV=production
Environment=NODE_PORT=8000
Type=simple
User=dwai
ExecStart=/usr/bin/node ${BIN_PATH}/start.js
Restart=on-failure
	
[Install]
WantedBy=multi-user.target
HERE
	chmod 664 ${SVC_PATH}
	systemctl daemon-reload || failed "Could not set permissions"
	systemctl enable ${SVC_NAME} || failed "Could not enable service"
	
}

function start()
{
	systemctl start ${SVC_NAME} || failed "Could not start service"
}

function stop()
{
	systemctl stop ${SVC_NAME} || failed "Coult not stop service"
}

function uninstall()
{
	systemctl disable ${SVC_NAME} || failed "Could not disable service"
	if [ -f ${SVC_PATH} ]; then
		rm ${SVC_PATH}
		echo "Uninstall success!"
	fi
}

function status()
{
	systemctl --no-pager status ${SVC_NAME}	
}

function usage()
{
	echo "Usage:"
	echo "./svc.sh [install, uninstall, start, stop, status"]
	echo
}
	
case $SVC_CMD in 
	"install") install;;
	"uninstall") uninstall;;
	"start") start;;
	"stop") stop;;
	"status") status;;
	*) usage;;
esac

exit 0
