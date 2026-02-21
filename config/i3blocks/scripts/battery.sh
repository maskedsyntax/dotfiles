#!/bin/bash
# battery.sh

# Use upower to get the device path for BAT1
battery_device=$(upower -e | grep 'BAT1')
if [ -n "$battery_device" ]; then
    # Extract and print the percentage from the battery's details
    upower -i "$battery_device" | awk '/percentage/ {print $2}'
else
    echo "Battery info not available"
fi
