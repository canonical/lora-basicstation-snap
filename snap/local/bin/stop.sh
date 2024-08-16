#!/bin/bash -eu

# When the snap is stopped or restarted, we always stop and remove the container.
# This is so that it gets recreated with the latest config.env file when it starts.

container_name="$SNAP_INSTANCE_NAME"

docker stop "$container_name" || true
docker rm -f "$container_name" || true
