#!/bin/sh
sudo -v
sudo pacman -Syyu
sudo pacman -S iw wpa_supplicant dialog intel-ucode git reflector lshw unzip htop --needed --noconfirm
sudo pacman -S curl wget pulseaudio alsa-utils alsa-plugins pavucontrol xdg-user-dirs --needed --noconfirm
sudo pacman -S base-devel --needed --noconfirm

# Install paru
git clone https://aur.archlinux.org/paru.git paru_temp
cd paru_temp
makepkg -si --needed --noconfirm 
cd ../
sudo rm -rf paru_temp

# Improve laptop battery consumption
sudo pacman -S bluez bluez-utils blueman --needed --noconfirm
sudo systemctl enable bluetooth
sudo pacman -S tlp tlp-rdw powertop acpi --needed --noconfirm
sudo systemctl enable tlp
sudo systemctl enable tlp-sleep
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

# Enable SSD TRIM
sudo systemctl enable fstrim.timer

# Install i3 dependency
sudo pacman -S xorg-server xorg-apps xorg-xinit --needed --noconfirm
sudo pacman -S i3 i3-gaps i3blocks i3lock numlockx --needed --noconfirm

# Install display Manager
sudo pacman -S lightdm lightdm-gtk-greeter --needed --noconfirm
sudo systemctl enable lightdm

# Install some basic fonts
sudo pacman -S noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont --needed --noconfirm
sudo pacman -S ttf-liberation ttf-droid ttf-roboto terminus-font --needed --noconfirm

# Install nerd font
sudo pacman -S ttf-cascadia-code-nerd --needed --noconfirm

# Install tools on i3
sudo pacman -S rxvt-unicode ranger rofi dmenu --needed --noconfirm

# Install some GUI programs
sudo pacman -S firefox vlc --needed --noconfirm

# Install other tools
sudo pacman -S docker --needed --noconfirm
paru -S docker-desktop --needed --noconfirm

# Install ZSH & oh my zsh
sudo pacman -S zsh --needed --noconfirm
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/install.sh &&
    sed -i 's/CHSH=no/CHSH=yes/g' /tmp/install.sh &&
    echo "Y" | sh /tmp/install.sh 

# Config ZSH

