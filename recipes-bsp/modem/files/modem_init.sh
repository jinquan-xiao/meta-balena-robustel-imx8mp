#!/bin/sh
#modem reset
echo 1 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio1/direction
echo 0 > /sys/class/gpio/gpio1/value

#sim select
echo 133 > /sys/class/gpio/export
echo low > /sys/class/gpio/gpio133/direction
#sim1
echo 0 > /sys/class/gpio/gpio133/value

#modem power
echo 6 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio6/direction
echo 1 > /sys/class/gpio/gpio6/value

#modem gps
echo 3 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio3/direction
echo 1 > /sys/class/gpio/gpio3/value

#full power
echo 0 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio0/direction
echo 1 > /sys/class/gpio/gpio0/value

#modem power on
sleep 3
echo 0 > /sys/class/gpio/gpio6/value

index=0
while [ $((index++)) -lt 300 ]
do
    modem_path=$(mmcli -L | grep '/org/freedesktop/ModemManager' | head -n 1 | awk '{print $1}')
    if [ -z "$modem_path" ]; then
        sleep 3
        continue
    fi

    gps_enable=$(mmcli -m "$modem_path" --command='AT+QGPS?' --timeout=10 | grep -E "\+QGPS:" | awk -F [" "\'] '{print $4}')
    if [ "$gps_enable" != "1" ]; then
        mmcli -m "$modem_path" --command='AT+QGPS=1' --timeout=10
    fi

    #mbim
    usbnet=$(mmcli -m "$modem_path" --command='AT+QCFG="usbnet"' --timeout=10 | grep -E '\+QCFG: "usbnet"' | awk -F [,\'] '{print $3}')
    if [ "$usbnet" != "2" ]; then
        mmcli -m "$modem_path" --command='AT+QCFG="usbnet",2' --timeout=10
    fi

    exit 0
done

exit 1