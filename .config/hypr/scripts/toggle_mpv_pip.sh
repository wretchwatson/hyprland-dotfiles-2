#!/bin/bash

# MPV penceresinin ID'sini (address) bul (jq bağımlılığını kaldırdım)
WINDOW_ID=$(hyprctl clients | grep -B 10 "class: mpv" | grep "Window" | head -n 1 | awk '{print $2}')

# Eğer MPV açık değilse hiçbir şey yapma
if [ -z "$WINDOW_ID" ]; then
    notify-send "MPV" "Çalışan bir video bulunamadı." -i mpv
    exit 0
fi

# Pencerenin hangi workspace'te olduğunu bul
WORKSPACE=$(hyprctl clients | grep -A 10 "Window $WINDOW_ID" | grep "workspace:" | head -n 1 | sed 's/.*(\(.*\))/\1/')

if [[ "$WORKSPACE" == "special:magic" ]]; then
    # Eğer gizli alandaysa: Mevcut workspace'e getir ve tekrar pinle
    hyprctl dispatch movetoworkspace current,address:$WINDOW_ID
    hyprctl dispatch pin address:$WINDOW_ID
    notify-send "PiP" "Video geri getirildi ve pinlendi." -i mpv
else
    # Eğer görünürdeyse: Gizli alana gönder
    hyprctl dispatch movetoworkspace special:magic,address:$WINDOW_ID
    notify-send "PiP" "Video arka plana (gizli alana) alındı." -i mpv
fi
