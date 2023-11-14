#!/bin/sh
export ZSH_CONFIG="./src/zshconfig"
export ZSH_SCRIPTS="./src/zshconfig/scripts"
export CONFIG_PATH="$HOME/.config"
export DOTFILE_PATH="./src/dotfiles"

mkdir -p "$ZSH_SCRIPTS"

pacman_packages=(
    "base-devel"
    "gnupg"
    "grub"
    "iw"
    "wpa_supplicant"
    "wireless_tools"
    "networkmanager"
    "network-manager-applet"
    "ibus"
    "gnome-keyring"
    "zsh"
    "dialog"
    "intel-ucode"
    "reflector"
    "lshw"
    "htop"
    "alsa-utils"
    "alsa-plugins" 
    "pavucontrol" 
    "xdg-user-dirs" 
    "pulseaudio" 
    "bluez"
    "bluez-utils"
    "blueman"
    "tlp"
    "tlp-rdw"
    "powertop"
    "acpi"
    "curl"
    "unzip"
    "nano"
    "git"
    "wget"
    "exa"
    "feh"
    "xorg-server"
    "xorg-apps"
    "xorg-xinit"
    "i3"
    "i3-gaps"
    "i3blocks"
    "i3lock"
    "numlockx"
    "arduino-cli"
    "lightdm"
    "lightdm-webkit2-greeter"
    "noto-fonts"
    "ttf-ubuntu-font-family"
    "ttf-dejavu"
    "ttf-freefont"
    "ttf-liberation"
    "ttf-droid"
    "ttf-roboto"
    "terminus-font"
    "ttf-cascadia-code-nerd"
    "kitty"
    "ranger"
    "rofi"
    "dmenu"
    "xss-lock"
    "polybar"
    "firefox"
    "vlc"
    "opera"
    "docker"
    "docker-compose"
    "docker-buildx"
)

aur_packages=(
    "picom-allusive"
    "lightdm-webkit2-theme-glorious"
    "docker-desktop"
    "snapd"
    "notion-app-electron"
)

# pacman install with no-confirm & needed
pacman_install() {
    sudo pacman -Sq --needed --noconfirm "$@"
}

paru_install() {
    paru -Sq --sudoloop --needed --noconfirm "$@" 
}

ConfigSystem() {
    # Let user control wireless system
    sudo systemctl mask systemd-rfkill.service
    sudo systemctl mask systemd-rfkill.socket

    # Enable SSD TRIM
    sudo systemctl enable fstrim.timer

    # Enable Network Manager
    sudo systemctl enable NetworkManager

    # Bluetooh
    sudo systemctl enable bluetooth

    # Power
    sudo systemctl enable tlp

    # Display Manager
    sudo systemctl enable lightdm

    # Openssh Server
    sudo systemctl enable sshd

    # Enable docker
    sudo systemctl enable --now docker.service

    # Enable docker-desktop
    systemctl --user enable docker-desktop
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

ConfigWallpaperManager(){
    sudo mkdir -p "/usr/share/wallpapers"
    mkdir -p "$HOME/.wallpapers"
    cp -rf "./src/wallpapers" "$HOME/.wallpapers"
    sudo cp -rf "./src/wallpapers" "/usr/share/wallpapers"
    sudo chmod 644 /usr/share/wallpapers/*
}

ConfigLightDM() {
    sudo cp "./src/user.face" "/usr/share/icons/user.face"
    sudo sed -i 's/^#greeter-session=.*/greeter-session=lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf
    sudo cp -f "./src/lightdm-webkit2-greeter.conf"  /etc/lightdm/lightdm-webkit2-greeter.conf
    sudo chmod 644 /etc/lightdm/lightdm-webkit2-greeter.conf
}

ConfigUser() {
    git config --global user.name DACHXY
    git config --global user.email Danny10132024@gmail.com

    # Add user to tty group (vscode arduino extension)
    sudo usermod -aG tty "$USER"
    sudo chmod a+rw /dev/ttyACM0
}

CopyDotfiles() {
    cp -rf ./src/dotfiles/* "$CONFIG_PATH"
}

# === Main === #
sudo -v
sudo pacman -Syyu --needed --noconfirm

pacman_install "${pacman_packages[@]}"

# Install paru
if command -v paru &> /dev/null ; then
    echo "Paru is installed."
else
    echo "Paru is not installed."
    InstallParu
fi

paru_install "${aur_packages[@]}"

# Config snap class path
sudo ln -s /var/lib/snapd/snap /snap
# Install Official vscode
sudo snap install code --classic

# Install Oh My ZSH
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [ -d "$OH_MY_ZSH_DIR" ]; then
    echo "Oh My Zsh is installed."
else
    echo "Oh My Zsh is not installed."
    InstallOhMyZSH
fi

# Install Z (dir jumper)
InstallZJumper

# Install Antigen (zsh plugin install tool)
InstallAntigen

# Config Section
ConfigSystem
ConfigUser
ConfigZSH
ConfigWallpaperManager
ConfigLightDM

# Copy Dotfiles
CopyDotfiles

# go into zsh
zsh



