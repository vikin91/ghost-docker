#!/bin/bash

set -e

if ! which "docker"; then
	echo "Error: cannot find docker binary"
	exit 1
fi

if ! which "docker-compose"; then
	echo "Error: cannot find docker-compose binary"
	exit 1
fi

NAME="${1:-ghost}"

function num_volumes(){
	local NAME
	NAME=${1}
	if [ "$#" -ne 1 ]; then
		echo "0"
	fi
	NUM_VOLUMES="$(docker volume ls | grep -ic "\s${NAME}$")"
	echo "${NUM_VOLUMES}"
}

function volume_exists(){
	local NAME
	NAME="${1}"
	NUM="$(num_volumes "${NAME}")"
	if [ "${NUM}" -gt "0" ]; then
		return 0
	fi
	return 1
}

export VOLUMES
VOLUMES=( "${NAME}_apps" "${NAME}_data" "${NAME}_images" "${NAME}_themes" )
export DOCKER
DOCKER="$(which docker)"
export DOCKER_COMPOSE
DOCKER_COMPOSE="$(which docker-compose)"

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
	"${DOCKER}" rm helper
done

DATE="$(date +%Y-%m-%d-%H-%M-%S)"
BACKUP_NAME="backup-${NAME}-${DATE}.tar"

# Add dirs to tar archive
tar cfz "${BACKUP_NAME}.gz" "${DIRS[@]}"

# Delete copied directories
for DIR in "${DIRS[@]}"; do
	rm -r "${DIR}"
done
