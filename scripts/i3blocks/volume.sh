#!/bin/bash
# volume.sh

# Check for scroll events to adjust volume
if [ "$BLOCK_BUTTON" = "4" ]; then
    # Scroll up: increase volume by 5%
    amixer -q set Master 5%+ > /dev/null
elif [ "$BLOCK_BUTTON" = "5" ]; then
    # Scroll down: decrease volume by 5%
    amixer -q set Master 5%- > /dev/null
fi

# Output the current volume percentage
amixer get Master | awk -F'[][]' '/%/ { print $2; exit }'
