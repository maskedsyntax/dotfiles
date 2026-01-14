
#!/usr/bin/env bash

# if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
#   echo "%{B#CC000000}%{F#ff5555}[Mic: muted]%{B-}%{F-}"
# else
#   vol=$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '{print $5}' | head -n1)
#   echo "%{B#CC000000}%{F#E57373}Mic: $vol%{B-}%{F-}"
# fi

if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
  echo "muted"
else
  pactl get-source-volume @DEFAULT_SOURCE@ | awk '{print $5}' | head -n1
fi

