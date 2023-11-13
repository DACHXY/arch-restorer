#!/bin/sh
export ZSH_CONFIG="./src/zshconfig"
export ZSH_SCRIPTS="./src/zshconfig/scripts"

InstallParu() {
    git clone https://aur.archlinux.org/paru.git paru_temp
    cd paru_temp
    makepkg -si --needed --noconfirm 
    cd ../
    sudo rm -rf paru_temp
}

InstallOhMyZSH() {
    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/install.sh &&
    sed -i 's/CHSH=no/CHSH=yes/g' /tmp/install.sh &&
    echo "Y" | sh /tmp/install.sh 
}

InstallZJumper() {
    echo "Installing Z..."
    wget "https://raw.githubusercontent.com/rupa/z/master/z.sh" -O "$ZSH_SCRIPTS/z.sh"
    sudo chmod +x "$ZSH_SCRIPTS/z.sh"
    sudo chmod 777 "$ZSH_SCRIPTS/z.sh"
}

InstallAntigen() {
    echo "Installing Antigen..."
    curl -L git.io/antigen > "$ZSH_SCRIPTS/antigen.zsh"
    sudo chmod +x "$ZSH_SCRIPTS/antigen.zsh"
    sudo chmod 777 "$ZSH_SCRIPTS/antigen.zsh"
}

ConfigZSH() {
    cp "src/zshrc" "$HOME/.zshrc"
    cp -r "src/zshconfig" "$HOME/.zshconfig" 
    sudo chmod -R +x "$HOME/.zshconfig"
    sudo chmod +x "$HOME/.zshrc"
}

sudo -v
sudo pacman -Syyu --needed --noconfirm
sudo pacman -S iw wpa_supplicant dialog intel-ucode reflector lshw htop alsa-utils alsa-plugins pavucontrol xdg-user-dirs pulseaudio --needed --noconfirm
sudo pacman -S curl unzip nano git wget --needed --noconfirm
sudo pacman -S base-devel --needed --noconfirm

# Install paru
if command -v paru &> /dev/null ; then
    echo "Paru is installed."
else
    echo "Paru is not installed."
    InstallParu
fi

# Improve laptop battery consumption
sudo pacman -S bluez bluez-utils blueman --needed --noconfirm
sudo systemctl enable bluetooth
sudo pacman -S tlp tlp-rdw powertop acpi --needed --noconfirm
sudo systemctl enable tlp
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
sudo pacman -S firefox vlc opera code --needed --noconfirm

# Install other tools
paru -S docker-desktop --needed --noconfirm

# Install ZSH & oh my zsh
sudo pacman -S zsh --needed --noconfirm

# Install Oh My ZSH
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [ -d "$OH_MY_ZSH_DIR" ]; then
    echo "Oh My Zsh is installed."
else
    echo "Oh My Zsh is not installed."
    InstallOhMyZSH
fi

# Config ZSH
mkdir -p $ZSH_SCRIPTS

# Install Z
InstallZJumper

# Install Antigen (zsh plugin install tool)
InstallAntigen

ConfigZSH

# With LXAppearance you can change themes, icons, cursors or fonts.
# sudo pacman -S lxappearance --needed --noconfirm

# go into zsh
zsh



