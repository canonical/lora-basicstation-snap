# Build a custom Ubuntu Core Image for lora-basicstation

These instructions are written for, and tested with, a Raspberry Pi 5.
With some modification it should also work on other platforms.

Read [this guide](https://ubuntu.com/core/docs/build-an-image) on creating an Ubuntu Core image first, before you continue with this guide.

## Gadget Snap

Part of the custom image is a custom Gadget Snap.

Inside this directory run `git submodule update --init --recursive` to pull the latest upstream `pi-gadget` snap.

Inside the `pi-gadget` directory, edit the file `gadget.yaml`.
Add the content of `additions-to-gadget.yaml` to the end of `gadget.yaml`.
You will need to update the additions with your Landscape account name, and perhaps the Landscape server URL.
If you want to preconfigure WiFi, also update the WiFi SSID and password.

Then build the gadget snap:

```
cd pi-gadget
snapcraft -v
cd ..
```

## The model

The example `model.json` file in this directory includes `landscape-client`, `lora-basicstation` and `docker`.

All you need to do is to update the `authority-id` and `brand-id` fields, and then sign the model:

```
snap sign -k my-model-key model.json > model.model
```

## Building the image

After the model is signed, you can proceed with building an image from this model.
We provide the path to our custom gadget snap, so that it can be side-loaded into the image during the build process.

```
$ ubuntu-image snap --snap pi-gadget/pi_24-1_arm64.snap --validation=enforce model.model
[0] prepare_image
WARNING: the kernel for the specified UC20+ model does not carry assertion max formats information, assuming possibly incorrectly the kernel revision can use the same formats as snapd
WARNING: "pi" installed from local snaps disconnected from a store cannot be refreshed subsequently!
[1] load_gadget_yaml
[2] set_artifact_names
[3] populate_rootfs_contents
[4] generate_disk_info
[5] calculate_rootfs_size
[6] populate_bootfs_contents
[7] populate_prepare_partitions
[8] make_disk
[9] generate_snap_manifest
Build successful
```

During the build process you will see two warnings.

- The warning about the kernel is discussed [here](https://forum.snapcraft.io/t/ubuntu-image-warning-kernel-snap/37774/3).
- The warning about the `pi` snap is because we side-loaded our custom locally built snap. This snap is not provided via the Snap Store and it will therefore not get updates. To get updates for custom Gadget snaps like these you will need a [dedicated Snap Store](https://ubuntu.com/core/docs/dedicated-snap-stores).

If the build was successful you will find a file called `pi.img` in the working directory.

## Using the image

You can flash this image file to an SD card using Raspberry Pi Imager.
After flashing, insert the SD card into a Raspberry Pi and power it on.
If you have a monitor connected, you will see a login prompt after a couple of minutes.
It is not possible to log in here, as there is no user configured.

At this point the Pi should have registered with Landscape.

Follow the the guide [here](../landscape/README.md) to control your gateway via Landscape.
