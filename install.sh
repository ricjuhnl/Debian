#!/bin/bash

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
sudo apt update
sudo apt upgrade -y

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
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub org.keepassxc.KeePassXC -y

# download and install Vivaldi
wget https://downloads.vivaldi.com/stable/vivaldi-stable_6.2.3105.48-1_amd64.deb -O vivaldi.deb
sudo apt install ./vivaldi.deb -y

# download and install VScode
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code.deb
sudo apt install ./vivaldi.deb -y

# Configure Oh-My-Zsh and Antigen
cd /home/$username/
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
curl -L git.io/antigen > antigen.zsh

cd $builddir
cp dotfiles/.zshrc /home/$username/
cp dotfiles/.datahub /home/$username/

# Add Docker's official GPG key:
sudo apt install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install docker components
sudo nala install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#activate ZSH
sudo usermod --shell /bin/zsh $username

# Prompt the user to reboot
read -p "Reboot now? (yes/no): " REBOOT_CHOICE

# Check the user's choice and reboot if they entered "yes"
if [ "$REBOOT_CHOICE" = "yes" ]; then
    sudo reboot
else
    echo "You chose not to reboot. Please manually reboot your system if necessary."
fi
