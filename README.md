# LoRa Basic Station on Ubuntu Core

Ubuntu Core is an operating system that is designed for IoT devices.
It provides the familiar experience of Ubuntu, but with the stability and reliable updates required for edge devices.

Ubuntu Core is completely built up out of Snap packages.
These snaps are secure sandboxes, packaging everything from a kernel to user workloads.
Snaps provide the fundamentals for reliable over-the-air updates.

You can read more on Ubuntu Core and its features [here](https://ubuntu.com/core).

## Basic Station Snap

This snap bundles the LoRa Basics™ Station [Docker container](https://github.com/xoseperez/basicstation-docker) for deployment on Ubuntu Core.
The snap is available from the Snap Store, or it can be compiled using the source in this repository.

To install the snap from the Snap Store, run this command:

```
sudo snap install lora-basicstation
```

For more details on how to use this snap, how it works, or how to build it yourself, [read further here](companion-snap-compose/README.md).

## Creating an Ubuntu Core image for gateways

The reliable remote configuration, updates and rollbacks that the Ubuntu Core and Snap ecosystem provides is ideal for LoRa gateways.
In this guide you will learn how to create a custom Ubuntu Core image that bundles Basic Station,
along with the necessary tools for remote management.

A custom image will allow you to do a zero-touch deployment of a large number of devices, by simply installing the same image on all of them.
In the case of a Raspberry Pi this image is flashed to an SD card, inserted into the Pi, then powered up.
All the essential steps are automated, and customisation can be done remotely using Landscape.

Read more on creating a custom Ubuntu Core image for a LoRa gateway [here](ubuntu-core-image/README.md).

## Using Landscape to manage your gateways

[Landscape](https://ubuntu.com/landscape) is Canonical's remote management service for a fleet of devices running Ubuntu. It provides patching, auditing, access management, and more.
If you can script it, you can remotely execute it from Landscape.
[Landscape runs anywhere](https://ubuntu.com/landscape/pricing): self-hosted on premises, in air-gapped environments, and it is also available as a SaaS offering.

We use Landscape to personalise the custom Ubuntu Core image for our gateways.
The main personalisation that needs to happen is setting of the LNS URI and key.
You can read more about this in our guide [here](landscape/README.md).
