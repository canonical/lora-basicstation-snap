#!/bin/bash -eu

container_name="$SNAP_INSTANCE_NAME"
image_name="xoseperez/basicstation:$DOCKER_IMAGE_TAG"

_term() { 
  echo "Caught SIGTERM signal!" 
  docker stop "$container_name"
}

_kill() {
  echo "Caught SIGKILL signal!"
  kill -9 "$child"
}

trap _term SIGTERM
trap _kill SIGKILL

echo "Starting container ..."
docker run --interactive --rm \
    --name "$container_name" \
    --log-driver none \
    --env-file "$SNAP_COMMON/conf.env" \
    --device=/dev/spidev0.0:/dev/spidev0.0 \
    --device=/dev/gpiochip0:/dev/gpiochip0 \
    --device=/dev/gpiochip4:/dev/gpiochip4 \
    "$image_name" \
    start &

child=$!
wait
