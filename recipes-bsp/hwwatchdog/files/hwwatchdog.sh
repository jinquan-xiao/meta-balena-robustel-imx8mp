#!/bin/sh

case "$1" in
	start)
		watchdog -T 10 -t 5 /dev/watchdog0 &
		watchdog -T 60 -t 30 /dev/watchdog1 &

		if grep -qw "flasher" /proc/cmdline; then
			# Blink RUN led in 100ms on 100ms off to indicate flasher boot
			echo timer > /sys/class/leds/run/trigger
			echo 100 > /sys/class/leds/run/delay_on
			echo 100 > /sys/class/leds/run/delay_off
		else
			# Blink RUN led in 500ms on 500ms off to indicate normal boot
			echo timer > /sys/class/leds/run/trigger
			echo 500 > /sys/class/leds/run/delay_on
			echo 500 > /sys/class/leds/run/delay_off
		fi
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
