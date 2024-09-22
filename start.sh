#!/bin/bash -eu

docker compose --env-file $SNAP_COMMON/conf.env -f $SNAP/docker-compose.yaml up