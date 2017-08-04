#!/bin/bash

source "lib.sh"
source "config.sh"

IMAGE_TO_REMOVE="$("${DOCKER}" images --filter=reference='ghost:latest' -q)"

# TODO: check if update is required

echo "Stopping ghost"
"${DOCKER_COMPOSE}" down || echo "No need to stop. Continuing"
"${DOCKER}" stop "${IMAGE_TO_REMOVE}" || echo "No need to stop. Continuing"
echo "Removing cached ghost image"
"${DOCKER}" rmi "${IMAGE_TO_REMOVE}"

"./start.sh"
