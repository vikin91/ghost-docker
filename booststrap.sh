#!/bin/bash

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

if ! which -s "docker"; then
	echo "Error: cannot find docker binary"
	exit 1
fi

if ! which -s "docker-compose"; then
	echo "Error: cannot find docker-compose binary"
	exit 1
fi

if [ ! -f "docker-compose.yml" ]; then
	echo "Error: file docker-compose.yml does not exist in current directory"
	exit 1
fi

VOLUMES=( "ghost_apps" "ghost_data" "ghost_images" "ghost_themes" )
DOCKER="$(which docker)"

# Create volumes if required
for VOL in "${VOLUMES[@]}"; do
	# if [ volume_exists "${VOL}" ] - would test if string returned by function is empty
	if volume_exists "${VOL}"; then
		echo "Volume $VOL exists already - skipping creation"
	else
		echo "Creating volume $VOL"
		"${DOCKER}" volume create --name="${VOL}"
	fi
done

# Start
docker-compose up -d
