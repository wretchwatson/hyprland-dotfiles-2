#!/bin/bash
# Dış IP adresini al ve bildirim olarak göster

# IP bulma servisleri (yedekli)
IP=$(curl -s --connect-timeout 5 https://api.ipify.org || curl -s --connect-timeout 5 https://ifconfig.me)

if [ -n "$IP" ]; then
    notify-send "Dış IP Adresi (Public IP)" "$IP" -i network-transmit-receive
    # Pano kopyalamak istersen alttaki satırın başındaki # işaretini kaldır:
    # echo "$IP" | wl-copy
else
    notify-send "Hata" "Dış IP adresi alınamadı. İnternet bağlantını kontrol et." -u critical
fi
