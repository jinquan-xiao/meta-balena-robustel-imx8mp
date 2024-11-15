#!/bin/sh

case "$1" in
	start)
		watchdog -T 10 -t 5 /dev/watchdog0 &
		watchdog -T 60 -t 30 /dev/watchdog1 &
		echo timer > /sys/class/leds/run/trigger
		;;
	stop)
		pkill -f "watchdog -T 10 -t 5 /dev/watchdog0"
		pkill -f "watchdog -T 60 -t 30 /dev/watchdog1"
		echo none > /sys/class/leds/run/trigger
		;;
	*)
		echo "Usage: hwwatchdog.sh {start|stop}"
		exit 1
esac

exit 0
