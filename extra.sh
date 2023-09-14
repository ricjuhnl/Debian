#!/bin/bash

username=$(id -u -n 1000)

# Prompt the user for the Git token
read -p "Enter your Git token: " GIT_TOKEN

# Copy ssh files
mkdir -p extras
cd extras
git clone https://ricjuhnl:$GIT_TOKEN@github.com/ricjuhnl/dotfiles
cd dotfiles/
cp .git-credentials /home/$username/
cp .gitconfig /home/$username/
cp files/avatar.jpg /home/$username/Pictures
cp -r files/'Camera Roll' /home/$username/Pictures
cp files/Ricardo.kdbx /home/$username/Documents
cp files/'smb keepass.txt' /home/$username/Documents
cp -r files/Maintenance /home/$username/Documents
cp -r .ssh/ /home/$username/
