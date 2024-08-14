# LoRa Basic Station Snap

This is a [companion snap](https://ubuntu.com/core/docs/docker-companion-snap) for [LoRa Basics™ Station for Docker](https://github.com/xoseperez/basicstation-docker).
This companion snap allows running and configuring a LoRa gateway on Ubuntu Core devices.

## Tested platforms

* Ubuntu Server 24.04 + Raspberry Pi 5 + [Pi Supply IoT Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi) + [RAK833-SPI](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak833)

## Debugging

### Reset concentrator

```
sudo GPIO_CHIP="gpiochip4" RESET_GPIO="22" POWER_EN_GPIO=0 POWER_EN_LOGIC=0 ./reset.gpiod.sh
```

### Run with docker compose

Edit the `docker-compose.yaml` file with the correct environment variables for your setup.

Then start the container:

```
docker compose up
```

Check the logs to see if Basic Station is connecting to the LoRa Network Server,
the concentrator is started and calibrated successfully,
and packets are being received.
