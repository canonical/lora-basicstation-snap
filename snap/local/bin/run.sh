#!/bin/bash -eu

container_name="$SNAP_INSTANCE_NAME"
image_name="xoseperez/basicstation:$DOCKER_IMAGE_TAG"

echo "Creating container ..."
docker create \
  --name "$container_name" \
  --log-driver none \
  --env-file "$SNAP_COMMON/conf.env" \
  --privileged \
  "$image_name"

echo "Starting container ..."
docker start --attach "$container_name"
