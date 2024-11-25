#!/bin/sh

function  config_uart1_ttymxc0_ttyCOM2_D2_as_rs485() {
                echo 127 > /sys/class/gpio/export 2>/dev/null
                echo out > /sys/class/gpio/gpio127/direction
                echo 0 > /sys/class/gpio/gpio127/value
                echo 129 > /sys/class/gpio/export 2>/dev/null
                echo out > /sys/class/gpio/gpio129/direction
                echo 0 > /sys/class/gpio/gpio129/value
                sleep 1
                echo 1 > /sys/class/gpio/gpio127/value
}

function  config_uart3_ttymxc2_ttyCOM1_D1_as_rs232() {
                echo 130 > /sys/class/gpio/export 2>/dev/null
                echo out > /sys/class/gpio/gpio130/direction
                echo 0 > /sys/class/gpio/gpio130/value
                echo 128 > /sys/class/gpio/export 2>/dev/null
                echo out > /sys/class/gpio/gpio128/direction
                echo 1 > /sys/class/gpio/gpio128/value
                sleep 1
}

case "$1" in
	start)
		# Module imx-sdma must be installed before any process that will open a interface with SDMA
		modprobe imx-sdma

		# General Interface in Expansion Board
		mkdir /sys/kernel/config/device-tree/overlays/kza-zaa
		cat /boot/eg5120-kza-zaa.dtbo > /sys/kernel/config/device-tree/overlays/kza-zaa/dtbo 

		# Uarts in Expansion Board, can operate in RS232 or RS485 mode
		config_uart1_ttymxc0_ttyCOM2_D2_as_rs485
		mkdir /sys/kernel/config/device-tree/overlays/uart1                                  
		cat /boot/eg5120-if-uart1-rs485.dtbo > /sys/kernel/config/device-tree/overlays/uart1/dtbo
		config_uart3_ttymxc2_ttyCOM1_D1_as_rs232
		mkdir /sys/kernel/config/device-tree/overlays/uart3                                       
		cat /boot/eg5120-if-uart3-rs232.dtbo > /sys/kernel/config/device-tree/overlays/uart3/dtbo
		;;
	stop)
		;;
	*)
		echo "Usage: dtboverlay.sh {start|stop}"
		exit 1
esac

exit 0
