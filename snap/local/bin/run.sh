#!/bin/bash -eu

container_name="$SNAP_INSTANCE_NAME"
image_name="xoseperez/basicstation:$DOCKER_IMAGE_TAG"

# Always remove any existing container to force recreate with latest configs
docker rm -f "$container_name" || true

echo "Creating container ..."
docker create \
  --name "$container_name" \
  --log-driver none \
  --env-file "$SNAP_COMMON/conf.env" \
  --privileged \
  "$image_name"

echo "Starting container ..."
docker start --attach "$container_name"
