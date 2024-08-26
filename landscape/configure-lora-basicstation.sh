#!/bin/bash
{
python3 - << EOF
import time
from landscape.client import snap_http

# sudo snap connect lora-basicstation:docker docker:docker-daemon
snap_http.http.post(
    "/interfaces",
    {
        "action": "connect",
        "slots": [{"snap": "docker", "slot": "docker-daemon"}],
        "plugs": [{"snap": "lora-basicstation", "plug": "docker"}],
    },
)

# Configure seems to be async. Sleep 10 seconds to wait for it to finish.
# landscape.client.snap_http.http.SnapdHttpException: b'{"type":"error","status-code":409,"status":"Conflict","result":{"message":"snap \\"lora-basicstation-jpm\\" has \\"connect-snap\\" change in progress","kind":"snap-change-conflict","value":{"change-kind":"connect-snap","snap-name":"lora-basicstation-jpm"}}}'
# landscape.client.snap_http.http.SnapdHttpException: b'{"type":"error","status-code":400,"status":"Bad Request","result":{"message":"snap \\"lora-basicstation-jpm\\" has \\"configure-snap\\" change in progress"}}'
time.sleep(10)

# sudo snap connect lora-basicstation:docker-executables docker:docker-executables
snap_http.http.post(
    "/interfaces",
    {
        "action": "connect",
        "slots": [{"snap": "docker", "slot": "docker-executables"}],
        "plugs": [{"snap": "lora-basicstation", "plug": "docker-executables"}],
    },
)

time.sleep(10)

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

snap_http.restart("lora-basicstation")

EOF
} &> /tmp/scriptoutput