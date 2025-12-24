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

if [[ "$WORKSPACE" == "10" ]]; then
    # Eğer 10. workspace'teyse (gizliyse): Mevcut workspace'e getir (silent: focusu değiştirme)
    hyprctl dispatch movetoworkspacesilent current,address:$WINDOW_ADDR
    # Tekrar pinle
    if [ "$IS_PINNED" = "false" ]; then
        hyprctl dispatch pin address:$WINDOW_ADDR
    fi
    notify-send "PiP" "Video 10. workspace'ten geri getirildi." -i mpv
else
    # Eğer görünürdeyse: Önce pinliyse pini kaldır
    if [ "$IS_PINNED" = "true" ]; then
        hyprctl dispatch pin address:$WINDOW_ADDR
    fi
    # Sonra 10. workspace'e (arkaya) sessizce gönder (focusu değiştirme)
    hyprctl dispatch movetoworkspacesilent 10,address:$WINDOW_ADDR
    notify-send "PiP" "Video 10. workspace'e saklandı." -i mpv
fi
