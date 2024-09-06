#!/bin/bash -eu

container_name="$SNAP_INSTANCE_NAME"
image_name="xoseperez/basicstation:$DOCKER_IMAGE_TAG"

spi_device="$(snapctl get env.device)"
gpio_chip="$(snapctl get env.gpio-chip)"

# Always remove any existing container to force recreate with latest configs
docker rm -f "$container_name" || true

echo "Creating container ..."
docker create \
  --name "$container_name" \
  --log-driver none \
  --env-file "$SNAP_COMMON/conf.env" \
  --device "$spi_device:$spi_device" \
  --device "/dev/$gpio_chip:/dev/$gpio_chip" \
  "$image_name"

echo "Starting container ..."
docker start --attach "$container_name"
