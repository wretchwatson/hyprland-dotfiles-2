#!/bin/bash

# Configuration
directory=~/Wallpaper
monitor="DP-1"

# Ensure hyprpaper is running
if ! pgrep -x "hyprpaper" > /dev/null; then
    echo "Starting hyprpaper..."
    hyprpaper &
    sleep 3 # Wait for socket
fi

# Find a random image
if [ -d "$directory" ]; then
    random_background=$(find "$directory" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)

    if [ -n "$random_background" ]; then
        echo "Changing wallpaper to: $random_background"
        hyprctl hyprpaper preload "$random_background"
        hyprctl hyprpaper wallpaper "$monitor,$random_background"
        
        # Save for next reboot
        echo "preload = $random_background" > ~/.config/hypr/hyprpaper.conf
        echo "wallpaper = ,$random_background" >> ~/.config/hypr/hyprpaper.conf
        echo "splash = false" >> ~/.config/hypr/hyprpaper.conf
    fi
else
    echo "Directory not found: $directory"
fi
