#!/bin/bash

source "lib.sh"
source "config.sh"

echo "Starting ghost"

"${DOCKER_COMPOSE}" up -d

echo "Setting ghost URL to ${PAGE_URL}"

"${DOCKER_COMPOSE}" exec --user node blog ghost config url "${PAGE_URL}"

echo "Restarting ghost so that URL setting goes live"

"${DOCKER_COMPOSE}" restart blog
