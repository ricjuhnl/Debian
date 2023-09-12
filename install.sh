#!/bin/bash

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
sudo apt update
sudo apt upgrade -y

# Install nala
sudo apt install nala -y

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.themes
mkdir -p /home/$username/.config
mkdir -p /home/$username/.ssh
mkdir -p /home/$username/.local/share/fonts
mkdir -p /home/$username/.local/share/themes
cp -R dotconfig/* /home/$username/.config/
chown -R $username:$username /home/$username

# Installing Essential Programs
sudo nala install zsh curl keychain kitty x11-xserver-utils unzip wget build-essential network-manager-openconnect-gnome -y
# Installing Other less important Programs
sudo nala install neofetch flameshot micro papirus-icon-theme fonts-noto-color-emoji pip -y

# Download Nordic Theme
cd /home/$username/.themes
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir
sudo nala install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip
unzip Meslo.zip -d /home/$username/.local/share/fonts
chown $username:$username /home/$username/.local/share/fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Configure Oh-My-Zsh and Antigen
cd /home/$username/
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
curl -L git.io/antigen > antigen.zsh
chsh -s $(which zsh)

cp dotfiles/.zshrc /home/$username/.zshrc

cd $builddir

# Copy ssh files
mkdir -p ssh
cd ssh
git clone https://github.com/ricjuhnl/dotfiles
cd dotfiles/
cp -r .ssh/ /home/$username/
chown -R $username:$username /home/$username/.ssh