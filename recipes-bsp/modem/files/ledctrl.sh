#!/bin/sh

MODEM_IFNAME="wwan0"
LED_MODEM="modem"
LED_RSSI="rssi"
LED_NET="user"

led_ctrl() {
    local led_name="$1"
    local led_mode="$2"
    if [ -z "$led_name" ] || [ -z "$led_mode" ]; then
        return
    fi

    case "$led_mode" in
        ON)
            echo none > /sys/class/leds/"${led_name}"/trigger
            echo 1 > /sys/class/leds/"${led_name}"/brightness
            ;;
        OFF)
            echo none > /sys/class/leds/"${led_name}"/trigger
            echo 0 > /sys/class/leds/"${led_name}"/brightness
            ;;
        BLINK)
            echo timer > /sys/class/leds/"${led_name}"/trigger
            ;;
        GREEN)
            echo none > /sys/class/leds/"${led_name}"/trigger
            echo 1 > /sys/class/leds/"${led_name}"/brightness
            ;;
        RED)
            echo none > /sys/class/leds/"${led_name}"/trigger
            echo 2 > /sys/class/leds/"${led_name}"/brightness
            ;;
        YELLOW)
            echo none > /sys/class/leds/"${led_name}"/trigger
            echo 3 > /sys/class/leds/"${led_name}"/brightness
            ;;
        *)
            ;;
    esac
}

led_netdev_trigger() {
    local led_name="$1"
    local ifname="$2"
    if [ -z "$led_name" ] || [ -z "$ifname" ]; then
        return
    fi

    echo netdev > /sys/class/leds/"${led_name}"/trigger
    echo "$ifname" > /sys/class/leds/"${led_name}"/device_name
    echo 1 > /sys/class/leds/"${led_name}"/link
    echo 1 > /sys/class/leds/"${led_name}"/tx
    echo 1 > /sys/class/leds/"${led_name}"/rx
}

rat_led_ctrl() {
    local act="$1"
    local state="$2"
    if [ -z "$act" ]; then
        return
    fi

    case "$act" in
        GSM)
            led_ctrl "$LED_MODEM" "RED"
            led_netdev_trigger "$LED_MODEM" "$MODEM_IFNAME"
            if [ "$state" = "connected" ]; then
                led_ctrl "$LED_NET" "BLINK"
            else
                led_ctrl "$LED_NET" "OFF"
            fi
            ;;
        UMTS)
            led_ctrl "$LED_MODEM" "YELLOW"
            led_netdev_trigger "$LED_MODEM" "$MODEM_IFNAME"
            if [ "$state" = "connected" ]; then
                led_ctrl "$LED_NET" "BLINK"
            else
                led_ctrl "$LED_NET" "OFF"
            fi
            ;;
        LTE)
            led_ctrl "$LED_MODEM" "GREEN"
            led_netdev_trigger "$LED_MODEM" "$MODEM_IFNAME"
            if [ "$state" = "connected" ]; then
                led_ctrl "$LED_NET" "ON"
            else
                led_ctrl "$LED_NET" "OFF"
            fi
            ;;
        *)
            led_ctrl "$LED_MODEM" "OFF"
            led_ctrl "$LED_NET" "OFF"
            ;;
    esac
}

rsrp_led_ctrl() {
    local rsrp="$1"
    if [ -z "$rsrp" ]; then
        return
    fi

    if [ $((rsrp)) -ge -140 ] && [ $((rsrp)) -lt -105 ]; then
        led_ctrl "$LED_RSSI" "RED"
    elif [ $((rsrp)) -ge -105 ] && [ $((rsrp)) -lt -85 ]; then
        led_ctrl "$LED_RSSI" "YELLOW"
    elif [ $((rsrp)) -ge -85 ] && [ $((rsrp)) -le -44 ]; then
        led_ctrl "$LED_RSSI" "GREEN"
    else
        led_ctrl "$LED_RSSI" "OFF"
    fi
}

csq_led_ctrl() {
    local csq="$1"
    if [ -z "$csq" ]; then
        return
    fi

    if [ $((csq)) -gt 0 ] && [ $((csq)) -lt 10 ]; then
        led_ctrl "$LED_RSSI" "RED"
    elif [ $((csq)) -ge 10 ] && [ $((csq)) -lt 20 ]; then
        led_ctrl "$LED_RSSI" "YELLOW"
    elif [ $((csq)) -ge 20 ] && [ $((csq)) -le 31 ]; then
        led_ctrl "$LED_RSSI" "GREEN"
    else
        led_ctrl "$LED_RSSI" "OFF"
    fi
}

led_init() {
    led_ctrl "$LED_MODEM" "OFF"
    led_ctrl "$LED_RSSI" "OFF"
    led_ctrl "$LED_NET" "OFF"
}


modem_path=$(mmcli -L | grep '/org/freedesktop/ModemManager' | head -n 1 | awk '{print $1}')
if [ -z "$modem_path" ]; then
    led_init
    exit 0
fi

modem_state=$(mmcli -m "$modem_path" --output-keyvalue | grep -E "modem.generic.state " -m 1 | awk -F ': ' '{print $2}')
if [ "$modem_state" != "registered" ] && [ "$modem_state" != "connected" ]; then
    led_init
    exit 0
fi

rat=$(mmcli -m "$modem_path" --command='AT+COPS?' --timeout=10 | grep -E "\+COPS:" -m 1 | awk -F [,\'] '{print $5}')
case "$rat" in
    0 | 1 | 3)
        act="GSM"
        ;;
    2 | 4 | 5 |6 | 15)
        act="UMTS"
        ;;
    7 | 10)
        act="LTE"
        ;;
    *)
        act="UNKNOW"
        ;;
esac
rat_led_ctrl "$act" "$modem_state"

if [ "$act" = "LTE" ]; then
    rsrp=$(mmcli -m "$modem_path" --command='AT+QCSQ' --timeout=10 | grep -E "\+QCSQ:" -m 1 | awk -F [,] '{print $3}')
    if [ -n "$rsrp" ]; then
        rsrp_led_ctrl "$rsrp"
        exit 0
    fi
fi

csq=$(mmcli -m "0" --command='AT+CSQ' --timeout=10 | grep -E "\+CSQ:" -m 1 | awk -F [" ":,] '{print $5}')
csq_led_ctrl "$csq"

exit 0
