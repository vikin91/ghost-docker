#!/bin/bash

if ! which -s "docker"; then
	echo "Error: cannot find docker binary"
	exit 1
fi

if ! which -s "docker-compose"; then
	echo "Error: cannot find docker-compose binary"
	exit 1
fi

DOCKER="$(which docker)"
DOCKER_COMPOSE="$(which docker-compose)"
IMAGE_TO_REMOVE="$("${DOCKER}" images --filter=reference='ghost:latest' -q)"

# TODO: check if update is required

"${DOCKER_COMPOSE}" down
"${DOCKER}" stop "${IMAGE_TO_REMOVE}"
"${DOCKER}" rmi "${IMAGE_TO_REMOVE}"
"${DOCKER_COMPOSE}" up -d