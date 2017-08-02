#!/bin/bash

if ! which -s "docker"; then
	echo "Error: cannot find docker binary"
	exit 1
fi

VOLUMES=( "ghost_apps" "ghost_data" "ghost_images" "ghost_themes" )
DIRS=( )
DOCKER="$(which docker)"

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

