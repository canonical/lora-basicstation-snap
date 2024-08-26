# Build a custom Ubuntu Core Image for lora-basicstation

Part of the custom image is a custom Gadget Snap.

Inside this directory run `git submodule update --init --recursive` to pull the latest upstream `pi-gadget` snap.

Inside the `pi-gadget` directory, edit the file `gadget.yaml`.
Add the content of `additions-to-gadget.yaml` to the end of `gadget.yaml`.
You will need to update the additions with your Landscape account name, and perhaps the Landscape server URL.
If you want to preconfigure WiFi, also update the WiFi SSID and password.

Read [this guide](https://ubuntu.com/core/docs/build-an-image) to create an Ubuntu Core image if you have not done that yet.

Remember to update the `authority-id` and `brand-id` fields in `model.json`.

In summary steps to build the image are:

```
cd pi-gadget
snapcraft -v
cd ..
snap sign -k my-model-key model.json > model.model
ubuntu-image snap --snap pi-gadget/pi_24-1_arm64.snap model.model
```

This should result in a file `pi.img` in this directory.
You can flash this file to an SD card using Raspberry Pi Imager.
After flashing, insert the SD card into a Raspberry Pi and power it on.
If you have a monitor connected, after a couple of minutes you will see a login prompt.
It is not possible to log in here, as there is no user configured.

At this point the Pi should have registered with Landscape.
Log into Landscape, accept the pending computer, and start managing it from there.
