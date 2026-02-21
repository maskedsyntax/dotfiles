#!/bin/bash

case "$1" in
  fullscreen)
    grim - | tee ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H-%M-%S').png | wl-copy
    ;;
  select)
    grim -g "$(slurp)" - | tee ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H-%M-%S').png | wl-copy
    ;;
  window)
    grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).rect | \"\(.x),\(.y) \(.width)x\(.height)\"')" - | tee ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H-%M-%S').png | wl-copy
    ;;
esac

