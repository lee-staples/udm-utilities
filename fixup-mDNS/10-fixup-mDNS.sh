#!/bin/sh

## avahi-daemon in unifi-os container conflicts with UDM mdns reflector service when enabled due to --net=host !!!
## stopping and disabling avahi-daemon in unifi-os
podman exec unifi-os systemctl stop avahi-daemon
podman exec unifi-os systemctl disable avahi-daemon


# UDM mdns reflector service does not work when a domain-name is set
# /var/run/avahi-daemon.conf is created by core service on each boot
# editing and forcing restart a hard restart of avahi-daemon (SIGHUP, HUP and --reload do not reload avahi-daemon.conf
sed -i s/domain-name=/#domain-name=/ /var/run/avahi-daemon.conf
killall avahi-daemon
