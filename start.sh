#!/bin/bash

source "lib.sh"
source "config.sh"

echo "Starting ghost"

"${DOCKER_COMPOSE}" up -d

echo "Setting ghost URL to ${PAGE_URL}"

"${DOCKER_COMPOSE}" exec blog ghost config url "${PAGE_URL}"

echo "Restarting ghost"
"${DOCKER_COMPOSE}" restart blog