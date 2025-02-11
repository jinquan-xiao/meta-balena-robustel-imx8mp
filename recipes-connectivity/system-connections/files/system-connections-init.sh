#!/bin/sh
ETH0_IFNAME="eth0"
ETH1_IFNAME="eth1"
WLAN0_IFNAME="wlan0"
WWAN0_IFNAME="wwan0"

ETH0_CONNECTION="/etc/NetworkManager/system-connections/${ETH0_IFNAME}.nmconnection"
ETH1_CONNECTION="/etc/NetworkManager/system-connections/${ETH1_IFNAME}.nmconnection"
WLAN0_CONNECTION="/etc/NetworkManager/system-connections/${WLAN0_IFNAME}.nmconnection"
WWAN0_CONNECTION="/etc/NetworkManager/system-connections/${WWAN0_IFNAME}.nmconnection"

macs=$(/etc/connections/read-base-macaddr)
eth0_mac=$(echo "$macs" | grep "eth0" | awk -F= '{print $2}')
eth1_mac=$(echo "$macs" | grep "eth1" | awk -F= '{print $2}')
wlan0_mac=$(echo "$macs" | grep "wlan0" | awk -F= '{print $2}')

if ! ([ -e $ETH0_CONNECTION ]); then
    echo -e "[connection]
id=Wired ${ETH0_IFNAME}
type=ethernet
interface-name=${ETH0_IFNAME}
autoconnect=true

[ipv4]
method=auto
route-metric=200

[ipv6]
method=auto
route-metric=200
addr-gen-mode=stable-privacy

[ethernet]
cloned-mac-address=${eth0_mac}
mtu=1500
auto-negotiate=true" > $ETH0_CONNECTION

    chmod 0600 $ETH0_CONNECTION
fi

if ! ([ -e $ETH1_CONNECTION ]); then
    echo -e "[connection]
id=Wired ${ETH1_IFNAME}
type=ethernet
interface-name=${ETH1_IFNAME}
autoconnect=true

[ipv4]
method=shared
address1=192.168.0.1/24

[ipv6]
method=auto
addr-gen-mode=stable-privacy

[ethernet]
cloned-mac-address=${eth1_mac}
mtu=1500
auto-negotiate=true" > $ETH1_CONNECTION

    chmod 0600 $ETH1_CONNECTION
fi

if ! ([ -e $WLAN0_CONNECTION ]); then
    echo -e "[connection]
id=${WLAN0_IFNAME}
type=wifi
interface-name=${WLAN0_IFNAME}
autoconnect=false

[ipv4]
method=auto
route-metric=300

[ipv6]
method=auto
route-metric=300
addr-gen-mode=stable-privacy

[wifi]
mode=infrastructure
ssid=my-wifi
cloned-mac-address=${wlan0_mac}" > $WLAN0_CONNECTION

    chmod 0600 $WLAN0_CONNECTION
fi

if ! ([ -e $WWAN0_CONNECTION ]); then
    echo -e "[connection]
id=${WWAN0_IFNAME}
type=gsm
autoconnect=true

[ipv4]
method=auto
route-metric=100

[ipv6]
method=auto
route-metric=100
addr-gen-mode=stable-privacy

[gsm]
auto-config=true" > $WWAN0_CONNECTION

    chmod 0600 $WWAN0_CONNECTION
fi

exit 0

