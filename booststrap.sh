#!/bin/bash

source "lib.sh"

if [ ! -f "docker-compose.yml" ]; then
	echo "Error: file docker-compose.yml does not exist in current directory"
	exit 1
fi


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
"${DOCKER_COMPOSE}" up -d
# Add config file
"${DOCKER}" cp config.production.json ghost:/var/lib/ghost/config.production.json

"${DOCKER_COMPOSE}" restart blog