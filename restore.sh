#!/bin/bash

source "lib.sh"

ARCHIVE="${1}"

if [ "$#" -ne 1 ]; then
	echo "Usage: ${0} <archive>"
	exit 1
fi

TMP="/tmp/ghost-backup-restore"

if [ -d "${TMP}" ];then
	rm -rf "${TMP}"
fi

mkdir -p "${TMP}"

tar -xzf "${ARCHIVE}" -C "${TMP}"

EXTRACTED_DIRS=( $(find "${TMP}" -mindepth 1 -maxdepth 1 -type d) )


for DIR in "${EXTRACTED_DIRS[@]}"; do
	BASE_DIR="$(basename "${DIR}")"
	echo "Restoring ${TMP}/${BASE_DIR} to docker volume ghost_${BASE_DIR}"
	"${DOCKER}" run --rm -v "ghost_${BASE_DIR}:/${BASE_DIR}" --name helper busybox true
	"${DOCKER}" cp -L "${TMP}/${BASE_DIR}" helper:/"${BASE_DIR}"
done


