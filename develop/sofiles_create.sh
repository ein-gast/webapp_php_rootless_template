#!/usr/bin/env sh

cd "$(dirname "$0")"/..

. ./site_sync_cfg || exit 1

INTERMEDIATE_IMAGE="localhost/$SITE_HTTP_HOST:latest"

docker build -t "$INTERMEDIATE_IMAGE" -f ./docker-build/Dockerfile ./docker-build || exit 1
CONTAINER=$(docker create "$INTERMEDIATE_IMAGE") || exit 1
docker cp $CONTAINER:/sofiles.tar - | tar -O -x sofiles.tar | tar -x -C ./volumes
docker rm -v $CONTAINER
