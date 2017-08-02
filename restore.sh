#!/bin/bash

if ! which -s "docker"; then
	echo "Error: cannot find docker binary"
	exit 1
fi

ARCHIVE="${1}"

if [ "$#" -ne 1 ]; then
	echo "Usage: ${0} <archive>"
	exit 1
fi

DOCKER="$(which docker)"

TMP="/tmp/ghost-backup-restore"
mkdir -p "${TMP}"

tar -xzf "${ARCHIVE}" -C "${TMP}"

EXTRACTED_DIRS=( $(find "${TMP}" -mindepth 1 -maxdepth 1 -type d) )


for DIR in "${EXTRACTED_DIRS[@]}"; do
	BASE_DIR="$(basename "${DIR}")"
	echo "Restoring ${TMP}/${BASE_DIR} to docker volume ghost_${BASE_DIR}"
	"${DOCKER}" run -v "ghost_${BASE_DIR}:/${BASE_DIR}" --name helper busybox true
	"${DOCKER}" cp -L "${TMP}/${BASE_DIR}" helper:/"${BASE_DIR}"
	"${DOCKER}" rm helper > /dev/null 2>&1
done


