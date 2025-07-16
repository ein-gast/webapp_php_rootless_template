#!/usr/bin/env sh

if ! command -v make > /dev/null; then
    echo "Not foud required tool: make"; exit 1;
fi

if ! command -v rsync > /dev/null; then
    echo "Not foud required tool: rsync"; exit 1;
fi

if ! command -v docker > /dev/null; then
    echo "Not foud required tool: docker"; exit 1;
fi

echo "all required tools - OK"
