#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run nm-applet
# run xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 1920x0 --rotate normal
run xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output HDMI-1-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal 
run nitrogen --restore
run flameshot
