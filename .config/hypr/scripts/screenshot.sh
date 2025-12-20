#!/bin/bash

DIR="$HOME/Resimler"
mkdir -p "$DIR"

NAME="screenshot_$(date +%Y%m%d_%H%M%S).png"

if [ "$1" == "area" ]; then
    grim -g "$(slurp)" "$DIR/$NAME"
elif [ "$1" == "full" ]; then
    grim "$DIR/$NAME"
fi

if [ -f "$DIR/$NAME" ]; then
    notify-send "Ekran Görüntüsü Alındı" "Kaydedildi: $DIR/$NAME" -i "$DIR/$NAME"
fi
