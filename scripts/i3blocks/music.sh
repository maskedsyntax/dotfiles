#!/bin/bash
if command -v playerctl &>/dev/null; then
    playerctl --player=spotify metadata --format '{{ artist }} - {{ title }}'
else
    echo "Spotify not running"
fi
