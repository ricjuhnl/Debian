#!/bin/bash

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
sudo apt update
sudo apt upgrade -y

# Prompt the user for the Git token
read -p "Enter your Git token: " GIT_TOKEN

# Install nala
sudo apt install nala -y

# Install flatpak
sudo apt install flatpak -y

# Add flatpak repo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.ssh
mkdir -p /home/$username/.local/share/fonts
cp -R dotconfig/* /home/$username/.config/
sudo chown -R $username:$username /home/$username

# Installing Essential Programs
sudo nala install zsh curl keychain x11-xserver-utils unzip wget build-essential network-manager-openconnect -y
# Installing Other less important Programs
sudo nala install neofetch flameshot kitty micro fonts-noto-color-emoji pip appstream-util -y

# Installing fonts
cd $builddir
sudo nala install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip
unzip Meslo.zip -d /home/$username/.local/share/fonts
sudo chown $username:$username /home/$username/.local/share/fonts/*

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

# Install flatpak packages
flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub org.keepassxc.KeePassXC -y

# download and install Vivaldi
wget https://downloads.vivaldi.com/stable/vivaldi-stable_6.2.3105.48-1_amd64.deb -O vivaldi.deb
sudo dpkg -i vivaldi.deb
rm vivaldi.deb

# Configure Oh-My-Zsh and Antigen
cd /home/$username/
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
curl -L git.io/antigen > antigen.zsh

cd $builddir
cp dotfiles/.zshrc /home/$username/
cp dotfiles/.datahub /home/$username/

# Copy ssh files
mkdir -p ssh
cd ssh
git clone https://$GIT_TOKEN@github.com/ricjuhnl/dotfiles
cd dotfiles/
cp -r .ssh/ /home/$username/
cd $builddir
rm -rf ssh

#activate ZSH
sudo usermod --shell /bin/zsh $username