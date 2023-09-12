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
sudo mkdir /usr/share/themes
cp -R dotconfig/* /home/$username/.config/
sudo chown -R $username:$username /home/$username

# Installing Essential Programs
sudo nala install zsh curl keychain kitty x11-xserver-utils unzip wget build-essential network-manager-openconnect-gnome gtk2-engines-murrine -y
# Installing Other less important Programs
sudo nala install neofetch flameshot micro papirus-icon-theme fonts-noto-color-emoji pip ostree appstream-util sassc -y

# Download and install Theme
git clone https://github.com/vinceliuice/Graphite-gtk-theme
cd Graphite-gtk-theme
./install.sh -s compact -c dark -l
cd $builddir
rm -rf Graphite-gtk-theme
gsettings set org.gnome.desktop.interface gtk-theme Graphite-Dark-compact
gsettings set org.gnome.desktop.wm.preferences theme Graphite-Dark-compact

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
git clone https://github.com/ricjuhnl/dotfiles
cd dotfiles/
cp -r .ssh/ /home/$username/
sudo chown -R $username:$username /home/$username/.ssh

#activate ZSH
sudo usermod --shell /bin/zsh $username