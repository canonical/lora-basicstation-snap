# LoRa Basic Station Snap

This is a [companion snap](https://ubuntu.com/core/docs/docker-companion-snap) for [LoRa Basics™ Station for Docker](https://github.com/xoseperez/basicstation-docker).
This companion snap allows running and configuring a LoRa gateway on Ubuntu Core devices.

## Usage

Build and install the snap:

```
snapcraft -v
sudo snap install --dangerous ./lora-basicstation_v2.8.3_arm64.snap
```

Connect the required docker interfaces:

```
sudo snap connect lora-basicstation:docker docker:docker-daemon
sudo snap connect lora-basicstation:docker-executables docker:docker-executables
```

Configure your gateway:

```
sudo snap set env.lora-basicstation tc-uri="wss://eu1.cloud.thethings.network:8887"
sudo snap set env.lora-basicstation tc-key=NNSXS...
```

Or with a single command:

```
sudo snap set lora-basicstation env.gateway-eui=DEADFFFEBEEF env.model=SX1301 env.tc-key=NNSXS... env.tc-uri=wss://eu1.cloud.thethings.network:8887 env.device=/dev/spidev0.0 env.interface=SPI env.spi-speed=200000 env.use-libgpiod=1 env.gpio-chip=gpiochip4 env.reset-gpio=22
```

Start the service and check the logs:

```
sudo snap start lora-basicstation
sudo snap logs -f lora-basicstation
```

The gateway software can be stopped using:

```
sudo snap stop lora-basicstation
```

## Tested platforms

- Ubuntu Server 24.04 + Raspberry Pi 5 + [Pi Supply IoT Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi) + [RAK833-SPI](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak833)

## Debugging

### Reset concentrator

To manually reset the gateway concentrator hardware, you can toggle the reset GPIO pin. A conveniance script is provided to assist with this. The following example is for the Raspberry Pi 5. Replace `RESET_GPIO="22"` with the correct GPIO your concentrator is connected to. If you are using an older Raspberry Pi, set `GPIO_CHIP` to `gpiochip0`.

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
