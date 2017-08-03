#!/bin/bash

source "lib.sh"

GHOST_CONTENT_SRC="/var/www/ghost/content"

IMAGES="$(find ${GHOST_CONTENT_SRC}/images/)"

for E in "${IMAGES[@]}"; do
	"${DOCKER}" cp "${E}" ghost:/var/lib/ghost/content/images/
done


