#!/bin/bash
# music.sh

# 1. Check if playerctl is installed
if ! command -v playerctl &>/dev/null; then
    echo "No Spotify lul"
    exit 0
fi

# 2. Attempt to get the current Spotify track
track="$(playerctl --player=spotify metadata --format '{{ artist }} - {{ title }}' 2>/dev/null)"

# 3. If playerctl fails or returns empty, print "No Spotify lul"
if [ $? -ne 0 ] || [ -z "$track" ]; then
    echo "No Spotify LuL!"
else
    echo "$track"
fi
