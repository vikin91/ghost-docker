#!/bin/sh

if ! which "docker"; then
	echo "Error: cannot find docker binary"
	exit 1
fi

if ! which "docker-compose"; then
	echo "Error: cannot find docker-compose binary"
	exit 1
fi

function num_volumes(){
	local NAME
	NAME=${1}
	if [ "$#" -ne 1 ]; then
		echo "0"
	fi
	NUM_VOLUMES="$(docker volume ls | grep -c "${NAME}")"
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

VOLUMES=( "ghost_apps" "ghost_data" "ghost_images" "ghost_themes" )
DOCKER="$(which docker)"
DOCKER_COMPOSE="$(which docker-compose)"