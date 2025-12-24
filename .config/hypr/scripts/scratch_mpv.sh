#!/bin/bash

# Panodaki linki al
URL=$(wl-paste)

# Eğer link boşsa veya geçerli bir URL değilse uyarı ver
if [[ ! $URL =~ ^http ]]; then
    notify-send "Hata" "Panoda geçerli bir URL bulunamadı!" -i dialog-error
    exit 1
fi

# MPV'yi arka planda başlat
notify-send "PiP Başlatılıyor" "Video sol alt köşeye sabitleniyor..." -i mpv
mpv "$URL" > /dev/null 2>&1 &
disown
