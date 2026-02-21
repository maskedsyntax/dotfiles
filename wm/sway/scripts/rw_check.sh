#!/bin/bash

# Wait for 5 seconds to ensure Sway is fully initialized
sleep 5

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Get a random wallpaper from the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Log the wallpaper being set
echo "$(date) - Setting wallpaper: $WALLPAPER" >> "$HOME/wallpaper.log"

# Kill any existing swaybg processes
/usr/bin/pkill swaybg >> "$HOME/wallpaper.log" 2>&1

# Set the new wallpaper using swaybg
/usr/bin/swaybg -i "$WALLPAPER" --mode fill >> "$HOME/wallpaper.log" 2>&1 &

