#!/bin/bash

# Set the temporary file path for the blurred screenshot
screenshot='/tmp/screen.png'
blurred_screenshot='/tmp/blurred_screen.png'

# Get a random image from the ~/Pictures/Wallpapers/ directory
wallpaper_dir=~/Pictures/Wallpapers/
random_wallpaper=$(find "$wallpaper_dir" -type f | shuf -n 1)

# Take a screenshot
grim $screenshot

# Resize the random wallpaper to fit 1920x1080 resolution
magick "$random_wallpaper" -resize 1920x1080^ -gravity center -extent 1920x1080 /tmp/resized_wallpaper.png

# Apply a blur effect to the screenshot using ImageMagick (IMv7)
magick $screenshot -blur 0x8 $blurred_screenshot

# Overlay the random wallpaper onto the blurred screenshot
magick $blurred_screenshot "$random_wallpaper" -gravity center -composite $blurred_screenshot

# Lock the screen with swaylock, using the composite image
swaylock -i $blurred_screenshot

# Clean up: Remove the temporary files
rm $screenshot $blurred_screenshot

