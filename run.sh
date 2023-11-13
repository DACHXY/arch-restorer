#!/bin/sh
export ZSH_CONFIG="./src/zshconfig"
export ZSH_SCRIPTS="./src/zshconfig/scripts"
export CONFIG_PATH="$HOME/.config"
export DOTFILE_PATH="./src/dotfiles"

# pacman install with no-confirm & needed
pacman_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

paru_install() {
    paru -S --needed --noconfirm "$@" 
}

InstallDependencies() {
    pacman_install base-devel

    # Grub Tool
    pacman_install grub 

    # Network Tool
    pacman_install iw wpa_supplicant wireless_tools networkmanager network-manager-applet 

    # System Tool
    pacman_install gnome-keyring dialog intel-ucode reflector lshw htop alsa-utils alsa-plugins pavucontrol xdg-user-dirs pulseaudio 

    # Bluetooh
    pacman_install bluez bluez-utils blueman 
    sudo systemctl enable bluetooth

    # Power
    pacman_install tlp tlp-rdw powertop acpi 
    sudo systemctl enable tlp
}

InstallTools() {
    # Tools
    pacman_install curl unzip nano git wget 
}

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

Configi3wm(){
    des = "$CONFIG_PATH/i3/config"
    src = "$DOTFILE_PATH/i3config"
    chmod 777 "$src"
    cp -f "$src" "$des"
}

sudo -v
sudo pacman -Syyu --needed --noconfirm

InstallDependencies

# Let user control wireless system
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

# Install paru
if command -v paru &> /dev/null ; then
    echo "Paru is installed."
else
    echo "Paru is not installed."
    InstallParu
fi

# Enable SSD TRIM
sudo systemctl enable fstrim.timer

# Install i3 dependency
pacman_install xorg-server xorg-apps xorg-xinit
pacman_install i3 i3-gaps i3blocks i3lock numlockx

# Install Compositor
pacman_install picom

# Install display Manager
pacman_install lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

# Install some basic fonts
pacman_install noto-fonts ttf-ubuntu-font-family ttf-dejavu ttf-freefont
pacman_install ttf-liberation ttf-droid ttf-roboto terminus-font

# Install nerd font
pacman_install ttf-cascadia-code-nerd

# Install tools on i3
pacman_install kitty ranger rofi dmenu xss-lock

# Install some GUI programs
pacman_install firefox vlc opera code

# Install other tools
paru_install docker-desktop

# Install ZSH & oh my zsh
pacman_install zsh

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

# Install Z (dir jumper)
InstallZJumper

# Install Antigen (zsh plugin install tool)
InstallAntigen

# Config zshrc
ConfigZSH

# Config i3 wm
Configi3wm

# go into zsh
zsh



