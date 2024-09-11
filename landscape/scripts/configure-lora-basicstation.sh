#!/usr/bin/env python3

import time
from landscape.client import snap_http

print("snap connect lora-basicstation:docker docker:docker-daemon")
snap_http.http.post(
    "/interfaces",
    {
        "action": "connect",
        "slots": [{"snap": "docker", "slot": "docker-daemon"}],
        "plugs": [{"snap": "lora-basicstation", "plug": "docker"}],
    },
)

time.sleep(10)

print("snap connect lora-basicstation:docker-executables docker:docker-executables")
snap_http.http.post(
    "/interfaces",
    {
        "action": "connect",
        "slots": [{"snap": "docker", "slot": "docker-executables"}],
        "plugs": [{"snap": "lora-basicstation", "plug": "docker-executables"}],
    },
)

time.sleep(10)

print("Setting options")
snap_http.set_conf("lora-basicstation", {
	"env": {
		"gateway-eui": "<REDACTED>",
		"model": "SX1301",
		"tc-key": "NNSXS.<REDACTED>",
		"tc-uri": "wss://<REDACTED>.eu1.cloud.thethings.industries:8887",
		"device": "/dev/spidev0.0",
		"interface": "SPI",
		"spi-speed": "200000",
		"use-libgpiod": "1",
		"gpio-chip": "gpiochip4",
		"reset-gpio": "25"
	}
})

time.sleep(10)

print("Starting and enabling service")
snap_http.start("lora-basicstation", enable=True)
