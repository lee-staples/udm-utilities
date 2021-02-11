# Run Synchronous audio player UDM

## Features

1. Run SnapCast server on your UDM, very small footprint alpine container.  https://github.com/badaix/snapcast
2. Stream audio with mplayer
3. Snapcast webserver exposed as http://unifi:1780

todo AirShare/AirPort/dlna

## Requirements

1. You have already setup the on boot script described [here](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script)
2. For zeroconf need to fixup-mDNS described [here](https://github.com/lee-staples/udm-utilities/tree/master/fixup-mDNS)

## Customization

* You will need to configure internet stream source in snapserver.conf as defaults to:
   stream = pipe:///tmp/snapfifo?name=default
For example to stream your favorite dnbradio.com
   stream = process:///usr/bin/mplayer?name=dnbradio&params= http://source.dnbradio.com:10128/dnbradio_main.mp3  -really-quiet -novideo -channels 2 -srate 48000 -af format=s16le -ao pcm:file=/dev/stdout -cache 1000
* Customise Dockfile to add alternate providers

## Docker

The Dockerfile include, as you build it locally on your UDM 

```sh
podman build . -t snapcast-server
```

## Steps

1. Copy [20-snapcast.sh](20-snapcast.sh) to /mnt/data/on_boot.d.
2. Execute /mnt/data/on_boot.d/[20-snapcast.sh](20-snapcast.sh).
3. Customise streams [snapserver.conf](snapserver.conf).
4. Run the snapcast-server podman container.  Mounting sockets dbus and avahi sockets; configuration files snapserver.conf and server.json; publishing ports 1704,1705,1780
   below only publish ports to internal interface 192.168.0.1 customizer as required

    ```sh
     podman run --name snapcast --detach --rm \
        --volume /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket \
        --volume /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
        --volume /mnt/data/snapcast-server/snapserver.conf:/etc/snapserver.conf \
        --volume /mnt/data/snapcast-server/server.json:/root/.config/snapserver/server.json \
        --publish 192.168.0.1:1704:1704 --publish 192.168.0.1:1705:1705 --publish 192.168.0.1:1780:1780 \
        snapcast-server
    ```

5. Connect clients and listen to Synchronous audio player

