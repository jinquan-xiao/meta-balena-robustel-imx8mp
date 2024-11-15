#!/bin/sh

case "$1" in
	start)
		# Module imx-sdma must be installed before any process that will open a interface with SDMA
		modprobe imx-sdma

		# General Interface in Expansion Board
		mkdir /sys/kernel/config/device-tree/overlays/kza-zaa
		cat /boot/eg5120-kza-zaa.dtbo > /sys/kernel/config/device-tree/overlays/kza-zaa/dtbo 

		# Uarts in Expansion Board, can operate in RS232 or RS485 mode
		mkdir /sys/kernel/config/device-tree/overlays/uart1                                  
		cat /boot/eg5120-if-uart1-rs232.dtbo > /sys/kernel/config/device-tree/overlays/uart1/dtbo                       
		mkdir /sys/kernel/config/device-tree/overlays/uart3                                       
		cat /boot/eg5120-if-uart3-rs485.dtbo > /sys/kernel/config/device-tree/overlays/uart3/dtbo 
		;;
	stop)
		;;
	*)
		echo "Usage: dtboverlay.sh {start|stop}"
		exit 1
esac

exit 0
