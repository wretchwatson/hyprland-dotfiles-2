#!/bin/bash

# Panodaki linki al
URL=$(wl-paste)

# Eğer link boşsa veya geçerli bir URL değilse (basit kontrol) uyarı ver
if [[ ! $URL =~ ^http ]]; then
    notify-send "Hata" "Panoda geçerli bir URL bulunamadı!" -i dialog-error
    exit 1
fi

# MPV'yi arka planda (disown) başlat
notify-send "MPV Başlatılıyor" "$URL" -i mpv
mpv "$URL" > /dev/null 2>&1 &
disown

# Scratchpad alanını otomatik olarak aç (isteğe bağlı, videoyu hemen görmek için)
hyprctl dispatch togglespecialworkspace magic
