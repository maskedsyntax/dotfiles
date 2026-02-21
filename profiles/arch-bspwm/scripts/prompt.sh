#!/bin/bash

if [ "$(printf "No\nYes" | dmenu -i -p "$1")" = "Yes" ]; then
	   $2
fi
