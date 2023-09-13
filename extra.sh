#!/bin/bash

# Prompt the user for the Git token
read -p "Enter your Git token: " GIT_TOKEN

# Copy ssh files
mkdir -p extras
cd extras
git clone https://ricjuhnl:$GIT_TOKEN@github.com/ricjuhnl/dotfiles
cd dotfiles/
cp -r /files /home/$username/Documents
cp -r .ssh/ /home/$username/
