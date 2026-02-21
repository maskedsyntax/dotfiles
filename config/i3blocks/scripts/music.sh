#!/bin/bash
# music.sh — Get current YouTube Music song from Brave window title

# Check if xwininfo is installed
if ! command -v xwininfo &>/dev/null; then
    echo "xwininfo not found"
    exit 1
fi

# Try to extract the song title from the Brave window running YouTube Music
song_title=$(xwininfo -root -tree \
    | grep -i 'YouTube Music - ' \
    | sed -E 's/.*YouTube Music - (.*) - YouTube Music.*/\1/' \
    | head -n 1)

# If empty, show fallback
if [ -z "$song_title" ]; then
    echo "No YouTube Music LuL!"
else
    echo "$song_title"
fi
