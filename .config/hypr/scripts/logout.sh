#!/bin/bash
# Hızlı ve temiz çıkış için portal servislerini öldür
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall -e xdg-desktop-portal
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal-gnome

# Kısa bir bekleme (opsiyonel, bazen process'in ölmesi için gerekir)
sleep 1

# Hyprland'den çık
hyprctl dispatch exit
