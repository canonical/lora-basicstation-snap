#!/bin/bash -eu

echo "Running: docker compose -f $SNAP/docker-compose.yaml up"
docker compose -f $SNAP/docker-compose.yaml up
# docker compose up