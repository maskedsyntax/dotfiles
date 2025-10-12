#!/bin/bash

# Interval (seconds)
interval=1

while true; do
    # Memory (free -m)
    mem="$(free -m | awk '/^Mem/ {printf "Mem:%d/%dMB", $3, $2}')"

    # CPU (top -bn1)
    cpu="$(top -bn1 | grep "Cpu(s)" | awk '{printf "CPU:%.1f%%", $2 + $4}')"

    # Battery
    if command -v acpi &>/dev/null; then
        battery="$(acpi -b | awk -F', ' '{print "Bat:" $2}' | head -n1)"
    else
        battery="Bat:N/A"
    fi

    # Volume (amixer)
    if command -v amixer &>/dev/null; then
        vol="$(amixer get Master | awk -F'[][]' '/Left:/ { print "Vol:" $2; exit }')"
    else
        vol="Vol:N/A"
    fi

    # Date (your format)
    datetime="$(date '+[%A %d/%m/%Y %H:%M:%S]')"

    # Set status
    xsetroot -name "$mem | $cpu | $vol | $battery | $datetime"

    sleep "$interval"
done

