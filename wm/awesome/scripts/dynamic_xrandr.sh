#!/bin/bash

# Check if HDMI-1-0 is connected
if xrandr | grep "HDMI-1-0 connected"; then
    # If HDMI-1-0 is connected, configure both eDP-1 and HDMI-1-0
    xrandr --output eDP-1 --mode 1920x1080 --rate 120 --pos 0x0 --rotate normal \
           --output HDMI-1-0 --primary --mode 1920x1080 --rate 75 --pos 1920x0 --rotate normal
else
    # If HDMI-1-0 is not connected, only configure eDP-1
    xrandr --output eDP-1 --mode 1920x1080 --rate 120 --pos 0x0 --rotate normal \
           --output HDMI-1-0 --off
fi

