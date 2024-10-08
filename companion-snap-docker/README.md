> [!WARNING]
> The packaging method using Docker CLI for container management has been deprecated.
> Instead, refer to the [Docker Compose based packaging](./companion-snap-compose).

# LoRa Basic Station Snap

This is a [companion snap](https://ubuntu.com/core/docs/docker-companion-snap) for [LoRa Basics™ Station for Docker](https://github.com/xoseperez/basicstation-docker).
This companion snap allows running and configuring a LoRa gateway on Ubuntu Core devices.

## Building and installation

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

Snaps on Ubuntu Core normally run in a strictly confined sandbox.
This snap needs access to the Docker Engine on the host, so we need to allow this special permission from inside the sandbox.
To do that, connect the required Docker interfaces:

```
sudo snap connect lora-basicstation:docker docker:docker-daemon
sudo snap connect lora-basicstation:docker-executables docker:docker-executables
```

## Configuration

Configuration of the gateway is done similar to the Docker container, using the same config options as listed [here](https://github.com/xoseperez/basicstation-docker?tab=readme-ov-file#configure-the-gateway).
The only difference is that we use snap configs rather than environment variables.
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

You can also verify the options with `snap get`.
For example directly after installation you will see a number of defaults that are already set:

```
$ sudo snap get lora-basicstation env
Key            Value
env.device     /dev/spidev0.0
env.gpio-chip  gpiochip0
```

You will notice that this snap has the `env.device` and `env.gpio-chip` configs set by default.
These configs are required to forward the correct devices to the Docker container.
If you are using a Raspberry Pi 5 you will need to change the `env.gpio-chip` value to `gpiochip4`, otherwise the Docker container won't be able to reset the LoRa concentrator.

## Running the snap

The gateway software starts automatically after it is installed, and after a system restart.
You will however need to manually restart it after you changed the configurations.

The gateway software can be stopped using:

```
sudo snap stop lora-basicstation
```

And then to start it again:

```
sudo snap start lora-basicstation
```

To view the log output, run:

```
sudo snap logs -f lora-basicstation
```

## Tested platforms

| Host           | Operating System    | Hat                                                                                                                   | Concentrator                                                                                     | Reset GPIO                        |
| -------------- | ------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------- |
| Raspberry Pi 5 | Ubuntu Core 24      | [Pi Supply IoT Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi)                  | [RAK833-SPI](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak833) | GPIO_CHIP=gpiochip4 RESET_GPIO=22 |
| Raspberry Pi 5 | Ubuntu Server 24.04 | [Pi Supply IoT Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi)                  | [RAK833-SPI](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak833) | GPIO_CHIP=gpiochip4 RESET_GPIO=22 |
| Raspberry Pi 5 | Ubuntu Server 24.04 | [LoRaGo PORT HAT for Raspberry Pi](https://sandboxelectronics.com/?product=lorago-port-multi-channel-lorawan-gateway) | [LoRaGo PORT](https://sandboxelectronics.com/?p=2669)                                            | GPIO_CHIP=gpiochip4 RESET_GPIO=25 |
| Raspberry Pi 3 | Ubuntu Core 24      | [Pi Supply IoT Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi)                  | [RAK833-SPI](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak833) | GPIO_CHIP=gpiochip0 RESET_GPIO=22 |
| Raspberry Pi 3 | Ubuntu Core 24      | [Link Labs 868 MHz LoRaWAN RPi Shield](https://www.amazon.co.uk/868-MHz-LoRaWAN-RPi-Shield/dp/B01G7G54O2)             | SX1301 on Hat                                                                                    | GPIO_CHIP=gpiochip0 RESET_GPIO=5  |

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

In edge cases during development there might be a `lora-basicstation` Docker container running that is not controlled by the companion snap.
You can manually stop and remove it using:

```
sudo docker stop lora-basicstation
sudo docker rm -f lora-basicstation
```

The snap has been configured to automatically restart the service if it exited.
If you manually remove the Docker container while the snap is started, you should see it being automatically recreated after some amount of time.
This restart delay is configured in the `snapcraft.yaml` file.
