#!/bin/sh
ETH0_IFNAME="eth0"
ETH1_IFNAME="eth1"
WLAN0_IFNAME="wlan0"

if [ "$1" != "$ETH0_IFNAME" ] && [ "$1" != "$ETH1_IFNAME" ] && [ "$1" != "$WLAN0_IFNAME" ]; then
    exit 1
fi

/sbin/ifconfig $1 down
/sbin/ifconfig $1 hw ether $(/etc/connections/read-base-macaddr | grep $1 | awk -F= '{print $2}')