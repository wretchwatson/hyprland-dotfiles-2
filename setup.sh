#!/bin/bash

# Renkler
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}### Dotfiles Kurulumu Başlıyor... ###${NC}"

# 0. Ön Hazırlık (Git ve AUR Yardımcısı)
echo -e "${GREEN}[+] Ön gereksinimler kontrol ediliyor...${NC}"

# Git Kontrolü
if ! command -v git &> /dev/null; then
    echo "Git bulunamadı, yükleniyor..."
    sudo pacman -S --noconfirm git
fi

# Paru/Yay Kontrolü ve Kurulumu
if ! command -v paru &> /dev/null && ! command -v yay &> /dev/null; then
    echo "AUR yardımcısı bulunamadı. Paru kuruluyor..."
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
fi

# 1. Paketleri Yükle
echo -e "${GREEN}[+] Paketler yükleniyor...${NC}"
# Arch paketleri
sudo pacman -S --needed - < pkglist_native.txt
# AUR paketleri
echo -e "${GREEN}[+] AUR paketleri yükleniyor...${NC}"
paru -S --needed - < pkglist_aur.txt

# 2. Klasörleri Oluştur
mkdir -p ~/.config

# 3. Konfigürasyonları Linkle
echo -e "${GREEN}[+] Ayarlar sembolik link ile bağlanıyor...${NC}"

# Yedekleme fonksiyonu
backup_and_link() {
    src="$1"
    dest="$2"
    
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Yedekleniyor: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    if [ ! -L "$dest" ]; then
        ln -s "$src" "$dest"
        echo "Linklendi: $dest"
    else
        echo "Zaten linkli: $dest"
    fi
}

# Config klasörleri
backup_and_link "$HOME/dotfiles/.config/hypr" "$HOME/.config/hypr"
backup_and_link "$HOME/dotfiles/.config/waybar" "$HOME/.config/waybar"
backup_and_link "$HOME/dotfiles/.config/wofi" "$HOME/.config/wofi"
backup_and_link "$HOME/dotfiles/.config/kitty" "$HOME/.config/kitty"
backup_and_link "$HOME/dotfiles/.config/fastfetch" "$HOME/.config/fastfetch"
backup_and_link "$HOME/dotfiles/.config/qt6ct" "$HOME/.config/qt6ct"
backup_and_link "$HOME/dotfiles/.config/Kvantum" "$HOME/.config/Kvantum"
backup_and_link "$HOME/dotfiles/.config/Thunar" "$HOME/.config/Thunar"
backup_and_link "$HOME/dotfiles/.config/swaync" "$HOME/.config/swaync"
backup_and_link "$HOME/dotfiles/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
backup_and_link "$HOME/dotfiles/.config/gtk-4.0" "$HOME/.config/gtk-4.0"
backup_and_link "$HOME/dotfiles/.config/wlogout" "$HOME/.config/wlogout"
backup_and_link "$HOME/dotfiles/.config/mimeapps.list" "$HOME/.config/mimeapps.list"

# Dosyalar
backup_and_link "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
backup_and_link "$HOME/dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"
backup_and_link "$HOME/dotfiles/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
backup_and_link "$HOME/dotfiles/Wallpaper" "$HOME/Wallpaper"

# 4. Sistem Konfigürasyonları (Sudo gerektirir)
echo -e "${GREEN}[+] Sistem dosyaları kopyalanıyor (Sudo)...${NC}"
if [ -f "$HOME/dotfiles/etc/sddm.conf" ]; then
    echo "SDDM Config: /etc/sddm.conf"
    sudo cp "$HOME/dotfiles/etc/sddm.conf" /etc/sddm.conf
fi
if [ -d "$HOME/dotfiles/etc/sddm.conf.d" ]; then
    echo "SDDM Config Dir: /etc/sddm.conf.d/"
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -r "$HOME/dotfiles/etc/sddm.conf.d/." /etc/sddm.conf.d/
fi

# SDDM Servisini Aktif Et
echo -e "${GREEN}[+] SDDM servisi aktifleştiriliyor...${NC}"
sudo systemctl enable sddm

echo -e "${GREEN}### Kurulum Tamamlandı! ###${NC}"
echo "Lütfen yeni ayarların geçerli olması için oturumu kapatıp açın veya shell'i yeniden başlatın."
