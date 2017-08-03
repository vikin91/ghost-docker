#!/bin/bash

source "lib.sh"

GHOST_CONTENT_SRC="/var/www/ghost/content"
GHOST_CONTENT_DEST="/var/lib/ghost/content"

IMAGES="$(find ${GHOST_CONTENT_SRC}/images/ -maxdepth 1 ! -path ${GHOST_CONTENT_SRC}/images/ )"

for IMAGE in ${IMAGES}; do
	echo "Copying ${IMAGE}"
	"${DOCKER}" cp "${IMAGE}" ghost:"${GHOST_CONTENT_DEST}"/images/
done


