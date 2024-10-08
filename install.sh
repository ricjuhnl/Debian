#!/bin/bash

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
sudo apt update
sudo apt upgrade -y

# Install flatpak
sudo apt install flatpak -y

# Add flatpak repo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Making folders
mkdir -p /home/$username/.config
mkdir -p /home/$username/.local/share/fonts
sudo chown -R $username:$username /home/$username

# Installing Essential Programs
sudo apt install zsh curl picom keychain x11-xserver-utils unzip wget build-essential cifs-utils openconnect network-manager-openconnect network-manager-openconnect-gnome -y
# Installing Other less important Programs
sudo apt install nfs-common sshfs fastfetch kitty micro fonts-noto-color-emoji pip appstream-util papirus-icon-theme -y

# Installing fonts
cd $builddir
sudo apt install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.local/share/fonts
sudo chown $username:$username /home/$username/.local/share/fonts/*

# Reloading Font
fc-cache -vf

# Removing zip Files
rm ./FiraCode.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# Install flatpak packages
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub org.keepassxc.KeePassXC -y
flatpak install flathub us.zoom.Zoom -y

# Prompt the user to reboot
read -p "Reboot now? (y/n): " REBOOT_CHOICE
if [ "$REBOOT_CHOICE" = "y" ]; then
    sudo reboot
else
    echo "You chose not to reboot. Please manually reboot your system if necessary."
fi
