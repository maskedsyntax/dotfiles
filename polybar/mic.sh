
#!/usr/bin/env bash

if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
  echo "%{B#b3ff5555}%{F#000000}[Mic: muted]%{B-}%{F-}"
else
  vol=$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '{print $5}' | head -n1)
  echo "%{B#b3ffffff}%{F#000000}[Mic: $vol]%{B-}%{F-}"
fi

