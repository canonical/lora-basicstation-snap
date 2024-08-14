#!/bin/bash -eu

container_name="$SNAP_INSTANCE_NAME"
image_name="xoseperez/basicstation:$DOCKER_IMAGE_TAG"

# Kill contianer if it already exists
docker rm "$container_name" || true

#if [ ! "$(docker ps --all --quiet --filter name="$container_name")" ]; then
    echo "Container does not exist. Creating ..."
    docker create \
        --device=/dev/spidev0.0:/dev/spidev0.0 \
        --name "$container_name" \
        --log-driver none \
        --env-file "$SNAP_COMMON/conf.env" \
        "$image_name"
#fi

echo "Starting container ..."
docker start --attach "$container_name"
