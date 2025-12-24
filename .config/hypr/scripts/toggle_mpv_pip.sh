#!/bin/bash

# MPV penceresinin bilgilerini JSON formatında al
CLIENT_DATA=$(hyprctl clients -j | jq -r '.[] | select(.class == "mpv")')

# Eğer MPV açık değilse uyarı ver ve çık
if [ -z "$CLIENT_DATA" ]; then
    notify-send "MPV" "Çalışan bir video bulunamadı." -i mpv
    exit 0
fi

WINDOW_ADDR=$(echo "$CLIENT_DATA" | jq -r '.address')
WORKSPACE=$(echo "$CLIENT_DATA" | jq -r '.workspace.name')
IS_PINNED=$(echo "$CLIENT_DATA" | jq -r '.pinned')

if [[ "$WORKSPACE" == "special:magic" ]]; then
    # Eğer gizli alandaysa: Mevcut workspace'e getir
    hyprctl dispatch movetoworkspace current,address:$WINDOW_ADDR
    # Değilse pinle (her zaman pinli gelsin)
    if [ "$IS_PINNED" = "false" ]; then
        hyprctl dispatch pin address:$WINDOW_ADDR
    fi
    notify-send "PiP" "Video geri getirildi ve pinlendi." -i mpv
else
    # Eğer görünürdeyse: Önce pinliyse pini kaldır (gizlenmesi için şart)
    if [ "$IS_PINNED" = "true" ]; then
        hyprctl dispatch pin address:$WINDOW_ADDR
    fi
    # Sonra gizli alana gönder
    hyprctl dispatch movetoworkspace special:magic,address:$WINDOW_ADDR
    notify-send "PiP" "Video arka plana (gizli alana) alındı." -i mpv
fi
