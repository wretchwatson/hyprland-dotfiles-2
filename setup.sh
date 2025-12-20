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

# Scriptin bulunduğu dizini al
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 3. Kopyalama Fonksiyonu
echo -e "${GREEN}[+] Ayarlar kopyalanıyor...${NC}"

# Yedekleme ve kopyalama fonksiyonu
backup_and_copy() {
    src="$1"
    dest="$2"
    
    # Hedef bir sembolik link ise, önce onu kaldır (eski kurulumdan kalma olabilir)
    if [ -L "$dest" ]; then
        echo "Eski sembolik link kaldırılıyor: $dest"
        rm "$dest"
    fi

    # Hedef zaten varsa ve link değilse yedekle
    if [ -e "$dest" ]; then
        echo "Yedekleniyor: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    # Kopyala
    echo "Kopyalanıyor: $src -> $dest"
    cp -r "$src" "$dest"
}

# Config klasörleri
backup_and_copy "$SCRIPT_DIR/.config/hypr" "$HOME/.config/hypr"
backup_and_copy "$SCRIPT_DIR/.config/waybar" "$HOME/.config/waybar"
backup_and_copy "$SCRIPT_DIR/.config/wofi" "$HOME/.config/wofi"
backup_and_copy "$SCRIPT_DIR/.config/kitty" "$HOME/.config/kitty"
backup_and_copy "$SCRIPT_DIR/.config/fastfetch" "$HOME/.config/fastfetch"
backup_and_copy "$SCRIPT_DIR/.config/qt6ct" "$HOME/.config/qt6ct"
backup_and_copy "$SCRIPT_DIR/.config/Kvantum" "$HOME/.config/Kvantum"
backup_and_copy "$SCRIPT_DIR/.config/Thunar" "$HOME/.config/Thunar"
backup_and_copy "$SCRIPT_DIR/.config/swaync" "$HOME/.config/swaync"
backup_and_copy "$SCRIPT_DIR/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
backup_and_copy "$SCRIPT_DIR/.config/gtk-4.0" "$HOME/.config/gtk-4.0"
backup_and_copy "$SCRIPT_DIR/.config/wlogout" "$HOME/.config/wlogout"
backup_and_copy "$SCRIPT_DIR/.config/mimeapps.list" "$HOME/.config/mimeapps.list"

# Dosyalar
backup_and_copy "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
backup_and_copy "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
backup_and_copy "$SCRIPT_DIR/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
backup_and_copy "$SCRIPT_DIR/Wallpaper" "$HOME/Wallpaper"

# 4. Sistem Konfigürasyonları (Sudo gerektirir)
echo -e "${GREEN}[+] Sistem dosyaları kopyalanıyor (Sudo)...${NC}"
if [ -f "$SCRIPT_DIR/etc/sddm.conf" ]; then
    echo "SDDM Config: /etc/sddm.conf"
    sudo cp "$SCRIPT_DIR/etc/sddm.conf" /etc/sddm.conf
fi

# SDDM Servisini Aktif Et
echo -e "${GREEN}[+] SDDM servisi aktifleştiriliyor...${NC}"
sudo systemctl enable sddm

echo -e "${GREEN}### Kurulum Tamamlandı! ###${NC}"
echo "Lütfen yeni ayarların geçerli olması için oturumu kapatıp açın veya shell'i yeniden başlatın."
