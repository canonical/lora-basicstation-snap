#!/bin/bash -eu

# The LoRa Basic Station container does not exit when snapd sends it a SIGTERM.
# We therefore tell docker to forcibly stop the container.

container_name="$SNAP_INSTANCE_NAME"

docker rm -f "$container_name" || true
