#!/bin/bash

# MPV penceresinin ID'sini bul
WINDOW_ID=$(hyprctl clients -j | jq -r '.[] | select(.class == "mpv") | .address')

if [ -z "$WINDOW_ID" ]; then
    # Eğer MPV açık değilse Magic Link'i çağır (Pano boşsa uyarı verir)
    ~/.config/hypr/scripts/scratch_mpv.sh
    exit 0
fi

# Pencerenin hangi workspace'te olduğunu bul
WORKSPACE=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$WINDOW_ID\") | .workspace.name")

if [[ "$WORKSPACE" == "special:magic" ]]; then
    # Eğer gizli alandaysa: Aktif workspace'e getir ve pinle
    hyprctl dispatch movetoworkspace current,address:$WINDOW_ID
    hyprctl dispatch pin address:$WINDOW_ID
    hyprctl dispatch focuswindow address:$WINDOW_ID
else
    # Eğer aktif alandaysa: Gizli alana gönder (pin otomatik kalkar)
    hyprctl dispatch movetoworkspace special:magic,address:$WINDOW_ID
fi
