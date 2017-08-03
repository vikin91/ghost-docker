#!/bin/bash

source "lib.sh"

set -e

DIRS=( )

"${DOCKER}" rm helper || echo "No need to remove helper. Continuing"

# Copy data from docker volumes
for VOL in "${VOLUMES[@]}"; do
	# Equivalent: DIR="$(echo ${VOL} | sed 's/ghost_//g' )"
	DIR="${VOL//ghost_/}"
	DIRS+=( "${DIR}" )
	"${DOCKER}" run -v "${VOL}:/${DIR}" --name helper busybox true
	echo "Copying $DIR"
	"${DOCKER}" cp -L "helper:/${DIR}" .
	"${DOCKER}" rm helper > /dev/null 2>&1
done

DATE="$(date +%Y-%m-%d-%H-%M-%S)"
BACKUP_NAME="ghost-backup-${DATE}.tar"

# Add dirs to tar archive
tar cfz "${BACKUP_NAME}.gz" "${DIRS[@]}"

# Delete copied directories
for DIR in "${DIRS[@]}"; do
	rm -r "${DIR}"
done
