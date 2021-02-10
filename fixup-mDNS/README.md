#  Fix-up multicast DNS

## Features

1. **Stops conflicting services**: Stops and disables avahi-daemon running within the unifi-os container as conflicting with host UDM pod configured with "NetworkMode": "host".
2. **Bruce force override configuration**: The host UDM avahi-daemon.conf generated automatically by ubios-udapi-server when enabled by Multicast DNS is created with a line entry domain=<domain> causing the avahi-daemon to be unable to publish; so remove line entry and brute force restart. (avahi-daemon does not reload avahi-daemon.config using SIGHUP, HUP or --reload).

## Requirements

1. You have already setup the on boot script described [here](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script)
2. You have enable mDNS (Check via GUI or CLI cat /config/ubios-udapi-server/ubios-udapi-server.state | jq '.services.mdns'
  
## Steps

1. Run as root on UDM Pro to download and set permissions of on_boot.d script:
```sh
# Download 10-fixup from GitHub
curl -L https://raw.githubusercontent.com/boostchicken/udm-utilities/master/container-common/on_boot.d/10-fixup-mDNS.sh -o /mnt/data/on_boot.d/10-fixup-mDNS.sh;
# Set execute permission
chmod a+x /mnt/data/on_boot.d/10-fixup-mDNS.sh;
```
2. Review the script /mnt/data/on_boot.d/10-fixup-mDNS.sh and when happy execute it.
```sh
# Review script
cat /mnt/data/on_boot.d/10-fixup-mDNS.sh;
# Apply container-common settings
/mnt/data/on_boot.d/05-container-common.sh;
```
