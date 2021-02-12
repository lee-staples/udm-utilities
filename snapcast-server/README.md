# Run Synchronous audio player cast server on UDM

## Features

1. Run SnapCast server on your UDM, using debian container.  https://github.com/badaix/snapcast
2. Avahi and Dbus enabled installed for zeroconf
3. Mplayer install to stream audio

   Future version to expose http and enable client connection from AirPort/DLNA

## Requirements

1. You have already setup the on boot script described [here](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script)

## Customization

* You will need to configure internet stream source in snapserver.conf defaults to:
   stream = pipe:///tmp/snapfifo?name=default
  For example to stream your favorite dnbradio.com
   stream = process:///usr/bin/mplayer?name=dnbradio&params= http://source.dnbradio.com:10128/dnbradio_main.mp3  -really-quiet -novideo -channels 2 -srate 48000 -af format=s16le -ao pcm:file=/dev/stdout -cache 1000
* Customise Dockfile to add alternate sources.

## Docker

The official repo is lee.staples/snapcast-server-udm.  Latest will always refer to the latest builds, there are also tags for each snapcast-server-udm release (e.g. 1.0.0).

The Dockerfile is included, you can build it locally on your UDM if you don't want to pull from Docker Hub or make customizations

```sh
podman build . --tag snapcast-server-udm:latest
```

Building from another device is possible.  You must have [buildx](https://github.com/docker/buildx/) and qemu-static-user installed to do cross platform builds. This is useful if you want to mirror to a private repo

```sh
docker buildx build --platform linux/arm64/v8 --tag snapcast-server-udm:latest .
```

## Steps

1. Copy [20-br0.conflist](./20-br0.conflist) to /mnt/data/podman/cni this will create your podman network bridge to br0 requre CNI dhcp daemon to query network attached DHCP servers, update its values to reflect your environment.
2. Copy [10-snapcast.sh](./10-snapcast.sh) to /mnt/data/on_boot.d and update its values to reflect your environment.
3. Execute /mnt/data/on_boot.d/[10-snapcast.sh](./10-snapcast.sh)
4. Create /mnt/data/snapcast-server, copy [snapserver.conf](./snapserver.conf) and touch [server.json](./server.json)
5. Run the snapcast-server docker container.  Mounting configuration/settings files and selecting bridged network.
    ```sh
     podman run --detach --name snapcast-server --hostname snapcast-server --net br0 \
        --volume /mnt/data/snapcast-server/snapserver.conf:/etc/snapserver.conf \
        --volume /mnt/data/snapcast-server/server.json:/root/.config/snapserver/server.json \
        leestaples/snapcast-server-udm:latest
    ```
6. Connect clients and listen to synchronous audio playback.
