#!/bin/bash -e

## Example commands from upstream readme
# docker run -it --network host --rm xoseperez/basicstation:latest gateway_eui
# docker run -it --network host --rm -e GATEWAY_EUI_SOURCE=wlan0 xoseperez/basicstation:latest gateway_eui
# docker run -it --privileged --rm -e GATEWAY_EUI_SOURCE=chip xoseperez/basicstation:latest gateway_eui
# docker run --privileged --rm xoseperez/basicstation find_concentrator
# docker compose run basicstation find_concentrator
# docker run --privileged --rm -e RESET_GPIO="12 13" xoseperez/basicstation find_concentrator
# docker run --privileged --rm -e SCAN_SPI=0 xoseperez/basicstation find_concentrator

image_name="xoseperez/basicstation:$DOCKER_IMAGE_TAG"

docker run -it --rm \
    --network host \
    --privileged \
    --env-file "$SNAP_COMMON/conf.env" \
    --log-driver none \
    "$image_name" $@
