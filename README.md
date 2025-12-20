# My Arch Linux Dotfiles

Bu depo benim kişisel Hyprland, Waybar ve diğer araçlarımı içeren yapılandırma dosyalarımı barındırır.

## İçerik
- **Hyprland:** Pencere yöneticisi ayarları ve scriptler.
- **Waybar:** Üst bar özelleştirmeleri (CSS, modüller).
- **Wofi:** Uygulama başlatıcı teması.
- **Zsh & Fastfetch:** Terminal ve shell yapılandırması.
- **Görünüm:** GTK, Qt (qt6ct, Kvantum), Kitty, Thunar, SwayNC, Wlogout ayarları.
- **Wallpaper:** Duvar kağıtları koleksiyonu.
- **Sistem:** SDDM (Giriş ekranı) yapılandırmaları.

## Kurulum (Restore)

1. Depoyu klonlayın:
   ```bash
   git clone https://github.com/KULLANICI_ADI/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Kurulum scriptini çalıştırın:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

## Manuel İşlemler
- `setup.sh` paketleri `pkglist_native.txt` ve `pkglist_aur.txt` dosyalarından okuyarak yükler.
- Mevcut konfigürasyon dosyalarınızı `.backup` uzantısıyla yedekler ve yerlerine sembolik link (symlink) oluşturur.
