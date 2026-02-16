#!/bin/bash

# exit on error
set -e

local yay_install_link=https://aur.archlinux.org/yay.git
local dot_dir="$HOME/dotfiles"

echo "Starting setup..."

cd dotfiles

# update pacman
echo -e "\n[1/4] updating system"
sudo pacman -Syu --noconfirm

# installing packages
echo -e "\n[2/4] installing packages"
sudo pacman -S --needed --noconfirm - <$dot_dir/pkglist.txt

# install yay if not there
if ! command -v yay &>/dev/null; then
  echo -e "\n[3/4] installing yay"
  cd /tmp
  git clone $yay_install_link
  cd yay

  makepkg -si --noconfirm
  cd ..
  rm -rf yay

  cd $dot_dir
else
  echo -e "\n[3/4] yay already installed, skipping"
fi

# installing aur packages
yay -S --needed --noconfirm - <$dot_dir/pkglist_aur.txt

# create symlink
echo -e "\n[4/4] creating symlinks with GNU stow"
cd $dot_dir
stow -v --restow -t $HOME .

echo -e "Setup Complete"
