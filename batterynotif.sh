#!/bin/bash
export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ | tr '\0' '\n')

BATTERY_PATH=$(upower -e | grep battery)
LINE_POWER_PATH=$(upower -e | grep line_power)
BATTERY_PERCENTAGE=$(upower -i $BATTERY_PATH | grep 'percentage:' | awk '{ print $2 }' | sed 's/%//')
CABLE_PLUGGED=$(upower -i $LINE_POWER_PATH | grep -A2 'line-power' | grep online | awk '{ print $2 }')

if [[ $CABLE_PLUGGED == 'yes' ]]; then

    if [[ $BATTERY_PERCENTAGE -gt 80 ]]; then
        notify-send --urgency=critical "Battery optimization" "Battery reached 80%, unplug the power cable to optimize battery life."
    fi

else

    if [[ $BATTERY_PERCENTAGE -lt 30 ]]; then
        notify-send --urgency=critical "Battery optimization" "Battery is below 30%, plug in the power cable to optimize battery life."
    fi

fi
