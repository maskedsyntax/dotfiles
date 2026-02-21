#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Get a random wallpaper from the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Log the wallpaper being set
# echo "$(date) - Setting wallpaper: $WALLPAPER" >> ~/wallpaper.log

# Kill any existing swaybg processes
pkill swaybg

# Set the new wallpaper using swaybg
swaybg -i "$WALLPAPER" --mode fill &
