
FROM alpine:3.13.1

RUN apk update

RUN apk add snapcast

RUN apk add mplayer

ENTRYPOINT /usr/bin/snapserver

#podman build --tag snapcast-server .
#podman run --name snapcast --detach --rm --volume /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket --volume /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket --publish 192.168.0.1:1704:1704 --publish 192.168.0.1:1705:1705 --publish 192.168.0.1:1780:1780 --volume /mnt/data/snapcast-server/snapserver.conf:/etc/snapserver.conf --volume /mnt/data/snapcast-server/server.json:/root/.config/snapserver/server.json snapcast-server
#
#
#
#

