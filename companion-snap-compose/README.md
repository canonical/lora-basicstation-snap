# LoRa Basic Station Snap

This is a [companion snap](https://ubuntu.com/core/docs/docker-companion-snap) for [LoRa Basics™ Station for Docker](https://github.com/xoseperez/basicstation-docker).
This companion snap allows running and configuring a LoRa gateway on Ubuntu Core devices.

## Install the snap

> The snap is not yet available from the Snap Store.
> It is currently required to build it yourself.
> Refer to [Building the snap](#building-the-snap).

To install the snap from the Snap Store, run:

```
sudo snap install lora-basicstation
```

This snap needs to interact with the Docker Engine on the host.
To allow that, we connect the required docker interfaces:

```
sudo snap connect lora-basicstation:docker docker:docker-daemon
sudo snap connect lora-basicstation:docker-executables docker:docker-executables
```

## Configuration

Configuration of the gateway is done similar to the Docker container, 
using the same config options as listed in the [upstream documentation](https://github.com/xoseperez/basicstation-docker?tab=readme-ov-file#configure-the-gateway).
The only difference is that we use snap config options rather than environment variables.
It would be possible to create an environment variable file and pass that to Docker, but we prefer to use the standard snap configuration options.
This allows us to leverage the snap ecosystem to maintain and update our Ubuntu Core devices.

To translate from environment variables to snap options, we only need to change the name or key of the configuration option.
The values remain the same.
For the variable name, change it to lower case and replace underscores with hyphens.
Then prefix it with `env.`.

Example:
`GATEWAY_EUI=DEADFFFEBEEF` becomes `env.gateway-eui=DEADFFFEBEEF`

After you have the configs in this format, you can set them one by one using the `snap set` command:

```
sudo snap set lora-basicstation env.tc-uri="wss://eu1.cloud.thethings.network:8887"
sudo snap set lora-basicstation env.tc-key=NNSXS...
```

Or with a single command:

```
sudo snap set lora-basicstation \
    env.gateway-eui=DEADFFFEBEEF \
    env.model=SX1301 \
    env.tc-key=NNSXS... \
    env.tc-uri=wss://eu1.cloud.thethings.network:8887 \
    env.device=/dev/spidev0.0 \
    env.interface=SPI \
    env.spi-speed=200000 \
    env.use-libgpiod=1 \
    env.gpio-chip=gpiochip4 \
    env.reset-gpio=22
```

An option can be cleared with the `snap unset` command, ex:

```
sudo snap unset lora-basicstation env.gateway-eui
```

You can also verify the options with `snap get`.
For example directly after installation you will see a number of defaults that are already set:

```
$ sudo snap get lora-basicstation env
Key            Value
env.device     /dev/spidev0.0
env.gpio-chip  gpiochip0
```

This snap has the `env.device` and `env.gpio-chip` configs set by default.
These configs are required to forward the correct devices to the Docker container.
If you are using a Raspberry Pi 5 you will need to change the `env.gpio-chip` value to `gpiochip4`, otherwise the Docker container won't be able to reset the LoRa concentrator.

## Running the snap

Start the snap and enable the daemon to autostart in the future:

```
sudo snap start --enable lora-basicstation
```

The gateway software can be stopped using:

```
sudo snap stop lora-basicstation
```

To view the log output, run:

```
sudo snap logs -f lora-basicstation
```

Removing the snap is done with this command, which will also remove the Docker container and image:

```
sudo snap remove lora-basicstation
```

## Tested platforms

| Host           | Operating System    | Hat                                                                                                                   | Concentrator                                                                                     | Reset GPIO                        |
| -------------- | ------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------- |
| Raspberry Pi 5 | Ubuntu Core 24      | [Pi Supply IoT Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi)                  | [RAK833-SPI](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak833) | GPIO_CHIP=gpiochip4 RESET_GPIO=22 |
| Raspberry Pi 5 | Ubuntu Server 24.04 | [Pi Supply IoT Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi)                  | [RAK833-SPI](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak833) | GPIO_CHIP=gpiochip4 RESET_GPIO=22 |
| Raspberry Pi 5 | Ubuntu Server 24.04 | [LoRaGo PORT HAT for Raspberry Pi](https://sandboxelectronics.com/?product=lorago-port-multi-channel-lorawan-gateway) | [LoRaGo PORT](https://sandboxelectronics.com/?p=2669)                                            | GPIO_CHIP=gpiochip4 RESET_GPIO=25 |
| Raspberry Pi 3 | Ubuntu Core 24      | [Pi Supply IoT Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi)                  | [RAK833-SPI](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak833) | GPIO_CHIP=gpiochip0 RESET_GPIO=22 |
| Raspberry Pi 3 | Ubuntu Core 24      | [Link Labs 868 MHz LoRaWAN RPi Shield](https://www.amazon.co.uk/868-MHz-LoRaWAN-RPi-Shield/dp/B01G7G54O2)             | SX1301 on Hat                                                                                    | GPIO_CHIP=gpiochip0 RESET_GPIO=5  |

# Development

This is a companion snap for the Basic Station Docker container.
It means this snap is only responsible for managing the Docker container.
All application logic is still contained inside the Docker container, and managed by the Docker Engine.
This snap only manages the life cycle and configuration of the container by interacting with the Docker Engine.

The configuration of the container is done via a `docker-compose.yaml` file, which is available in this directory.
This file might require customisation for your specific use case.

Configuration of the application is still done via environment variables, but these are generated from snap options.
The translation of snap options to an environment file is done by the snap configure hook at `snap/hooks/configure`.

## Building the snap

We recommend you to build the snap on Ubuntu Server or Ubuntu Desktop.
It is not possible to build the snap on Ubuntu Core.
Make sure to build on a device with the same architecture as the device it will run on.
Alternatively you can do a [remote build](https://snapcraft.io/docs/remote-build).

Clone this repo, and then inside the cloned directory run the following command to build it.
If building is successful, a file named similar to `lora-basicstation_*_arm64.snap` will be created in the working directory.

```
snapcraft -v
```

You can copy this `.snap` file over to the Ubuntu Core device you want to install it on.
On the target device, install the snap using this command:

```
sudo snap install --dangerous ./lora-basicstation_*.snap
```

# Debugging

## Verify environment

The snap configs are translated to an environment file when this snap is started.
This environment file is passed to the Docker container when it is created.

You can verify the contents of the environment file with this command:

```
cat /var/snap/lora-basicstation/common/conf.env
```

## Verify that the Docker container is running

To make sure the Docker container is running, execute the following command.
If it does not list any containers with the name `lora-basicstation`, the container is not running.

```
sudo docker ps
```

## Find the Gateway EUI

This snap provides a tool to generate an EUI from the device MAC address.
Refer to the [upstream documentation](https://github.com/xoseperez/basicstation-docker?tab=readme-ov-file#get-the-eui-of-the-gateway) for details on its usage.

```
$ lora-basicstation.gateway-eui
Gateway EUI: 2CCF67FFFE1CBBA1 (based on interface eth0)
```

If the `env.gateway-eui` snap option is set, this tool will output the following:

```
$ lora-basicstation.gateway-eui
Gateway EUI: 0242ACFFFE110002 (based on environment variable)
```

## Find attached concentrators

A script to scan for connected LoRa concentrators is included.
Please see the [upstream documentation](https://github.com/xoseperez/basicstation-docker?tab=readme-ov-file#find-the-concentrator) for its limitation.

```
$ lora-basicstation.find-concentrator

Looking for devices, this might take some time...

DEVICE             DESIGN      ID
---------------------------------------------------

0 device(s) found!
```
