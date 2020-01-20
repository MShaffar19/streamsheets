#!/usr/bin/env bash

docker network ls | grep streamsheets > /dev/null || docker network create streamsheets

docker volume ls | grep streamsheets-data-dev > /dev/null || docker volume create streamsheets-data-dev

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
STREAMSHEETS_CONTAINER_EXISTS="$(docker ps -a -q --no-trunc --filter name=^streamsheets-dev$)"

if [ ! $STREAMSHEETS_CONTAINER_EXISTS ]
then
	echo "Creating and starting Streamsheets Docker container"
	docker run \
		-p 8081:8081 \
		-p 8083:8083 \
		-p 1883:1883 \
		-v $SCRIPT_LOCATION/settings/mosquitto:/etc/mosquitto-default-credentials \
		-v streamsheets-data-dev:/var/lib/mongodb \
		--name streamsheets-dev \
		--network streamsheets \
		cedalo/streamsheets-dev
else
	echo "Starting Streamsheets Docker container"
	docker start streamsheets-dev -a
fi