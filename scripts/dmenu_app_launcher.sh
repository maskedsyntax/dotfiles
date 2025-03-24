#!/bin/bash

# Define the directories containing .desktop files
APP_PATHS=(
    /usr/share/applications
    "$HOME/.local/share/applications"
    "$HOME/.local/share/flatpak/exports/share/applications"
    /var/lib/flatpak/exports/share/applications
)

# Build a list of apps with format "AppName|DesktopFilePath"
entries=$(find "${APP_PATHS[@]}" -name '*.desktop' 2>/dev/null | while read -r file; do
    # Prefer locale-specific name if available, otherwise default
    name=$(grep -E -m 1 '^Name(\[[^]]+\])?=' "$file" | head -n 1 | cut -d'=' -f2-)
    if [ -n "$name" ]; then
      echo "$name|$file"
    fi
done)

# Use dmenu to choose an app (displaying only the app name)
choice=$(echo "$entries" | cut -d'|' -f1 | sort -u | dmenu -i -p "Launch:")

# If no app was selected (e.g. ESC pressed), exit early
[ -z "$choice" ] && exit 1

# If a choice was made, locate the corresponding desktop file
selected_entry=$(echo "$entries" | grep -F "$choice|" | head -n 1)

if [ -n "$selected_entry" ]; then
    desktop_file=$(echo "$selected_entry" | cut -d'|' -f2)
    
    # Extract the Exec line from the desktop file.
    # Note: The Exec line can contain field codes like %U, %f, etc.
    exec_line=$(grep -E '^Exec=' "$desktop_file" | head -n 1 | cut -d'=' -f2-)
    
    # Remove common field codes (like %U, %u, %F, %f, etc.)
    exec_command=$(echo "$exec_line" | sed 's/ *%[fFuUdDnNikvm]//g')
    
    # Launch the application
    eval "$exec_command" &
fi

