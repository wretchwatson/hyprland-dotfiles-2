#!/bin/bash

# MPV penceresinin ID'sini (address) bul
WINDOW_ID=$(hyprctl clients -j | jq -r '.[] | select(.class == "mpv") | .address')

# Eğer MPV açık değilse hiçbir şey yapma
if [ -z "$WINDOW_ID" ]; then
    notify-send "MPV" "Çalışan bir video bulunamadı." -i mpv
    exit 0
fi

# Pencerenin hangi workspace'te olduğunu bul
WORKSPACE=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$WINDOW_ID\") | .workspace.name")

if [[ "$WORKSPACE" == "special:magic" ]]; then
    # Eğer gizli alandaysa: Mevcut workspace'e getir ve tekrar pinle
    hyprctl dispatch movetoworkspace current,address:$WINDOW_ID
    hyprctl dispatch pin address:$WINDOW_ID
    notify-send "PiP" "Video geri getirildi ve pinlendi." -i mpv
else
    # Eğer görünürdeyse: Gizli alana gönder (ses çalmaya devam eder)
    hyprctl dispatch movetoworkspace special:magic,address:$WINDOW_ID
    notify-send "PiP" "Video arka plana (gizli alana) alındı." -i mpv
fi
