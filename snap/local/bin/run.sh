#!/bin/bash -eu

container_name="$SNAP_INSTANCE_NAME"
image_name="xoseperez/basicstation:$DOCKER_IMAGE_TAG"

echo "Creating container ..."
docker create \
  --name "$container_name" \
  --log-driver none \
  --env-file "$SNAP_COMMON/conf.env" \
  --device=/dev/spidev0.0:/dev/spidev0.0 \
  --device=/dev/gpiochip0:/dev/gpiochip0 \
  --device=/dev/gpiochip4:/dev/gpiochip4 \
  "$image_name"

echo "Starting container ..."
docker start --attach "$container_name"
