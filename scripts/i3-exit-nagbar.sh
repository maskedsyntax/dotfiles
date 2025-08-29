#!/bin/bash

if xrandr --listmonitors | grep -q "HDMI-1-0"; then
    # Place nagbar on HDMI-1-0
    i3-nagbar -t warning -m 'Do you really want to exit i3?' \
        -B 'Yes, exit i3' 'i3-msg exit' -o HDMI-1-0
else
    # Fallback to laptop screen eDP-1
    i3-nagbar -t warning -m 'Do you really want to exit i3?' \
        -B 'Yes, exit i3' 'i3-msg exit' -o eDP-1
fi

