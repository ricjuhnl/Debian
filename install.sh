#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
mkdir /home/$username/build/
builddir=/home/$username/build/

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

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
nala install zsh curl keychain kitty x11-xserver-utils unzip wget build-essential network-manager-openconnect-gnome -y
# Installing Other less important Programs
nala install neofetch flameshot micro papirus-icon-theme fonts-noto-color-emoji pip -y

# Download Nordic Theme
cd /home/$username/.themes
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir
nala install fonts-font-awesome -y
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

# Configure Oh-My-Zsh and Antigen
cd /home/$username/
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
curl -L git.io/antigen > antigen.zsh
chsh -s $(which zsh)

cp dotfiles/.zshrc /home/$username/

cd $builddir

# Copy ssh files
git clone https://github.com/ricjuhnl/dotfiles
cd dotfiles/
cp -r .ssh/ /home/$username/

#delete build folder
rm -r /home/$username/build/