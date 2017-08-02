#!/bin/bash

source "lib.sh"

IMAGE_TO_REMOVE="$("${DOCKER}" images --filter=reference='ghost:latest' -q)"

# TODO: check if update is required

"${DOCKER_COMPOSE}" down
"${DOCKER}" stop "${IMAGE_TO_REMOVE}"
"${DOCKER}" rmi "${IMAGE_TO_REMOVE}"
"${DOCKER_COMPOSE}" up -d