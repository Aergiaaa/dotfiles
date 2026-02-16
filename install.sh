#!/bin/bash

# exit on error
set -e

yay_install_link=https://aur.archlinux.org/yay.git
dot_dir="$HOME/dotfiles"

echo "Starting setup..."

cd $HOME/dotfiles

# backing up
echo -e "\n[0/5] backing up"
echo -e "\n checking if fresh setup"
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo -e "existing dotfiles detected"
  echo -e "this script meant for fresh setup"
  echo ""

  read -p "do you want to backup and replace your existing files with dotfiles repo? (yes/no): " -r
  if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "installation canceled"
    exit 1
  fi

  BACKUP_DIR="$HOME/dotfiles_bak_$(date +%Y%m%d_%H%M%S)"
  echo -e "\nbacking up existing files"
  mkdir -p "$BACKUP_DIR"

  BACKUP_FILES=(
    ".zshrc"
    ".p10k.zsh"
    ".tmux.conf"
    ".xinitrc"
    ".zscript"
    ".config"
    ".oh-my-zsh"
    ".tmux"
    ".ssh"
  )

  for file in "${BACKUP_FILES[@]}"; do
    if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
      echo -e "  Backing up $file"
      mv "$HOME/$file" "$BACKUP_DIR/"
    fi
  done

  echo -e "backup complete: $BACKUP_DIR"
fi

# update pacman
echo -e "\n[1/5] updating system"
sudo pacman -Syu --noconfirm

# installing packages
echo -e "\n[2/5] installing packages"
sudo pacman -S --needed --noconfirm - <$dot_dir/pkglist.txt

# install yay if not there
if ! command -v yay &>/dev/null; then
  echo -e "\n[3/5] installing yay"
  cd /tmp
  git clone $yay_install_link
  cd yay

  makepkg -si --noconfirm
  cd ..
  rm -rf yay

  cd $dot_dir
else
  echo -e "\n[3/5] yay already installed, skipping"
fi

# installing aur packages
yay -S --needed --noconfirm - <$dot_dir/pkglist_aur.txt

# create symlink
echo -e "\n[4/5] creating symlinks with GNU stow"
cd $dot_dir
echo -e "cleaning links first"
find . -type l -lname '/*' -delete 2>/dev/null || true
echo -e "stowing now..."
stow -v --restow -t $HOME .

echo -e "\n[5/5] enabling services"
if [ -d "$HOME/.config/systemd/user" ]; then
  SYS_USER_SERVC=$(find "$HOME/.config/systemd/user" -maxdepth 1 -type f \( -name "*.service" -o -name "*.timer" \) -exec basename {} \;)

  if [ -n "$SYS_USER_SERVC" ]; then
    echo -e "enabling user services:"
    for s in $SYS_USER_SERVC; do
      echo -e "enabling $s"
      systemctl --user enable "$s" 2>/dev/null || echo -e "failed to enable $s"
    done

    echo -e "reloading user daemon"
    systemctl --user daemon-reload
    echo -e "services enabled"
  else
  fi
else
fi

if [ -f "$dot_dir/systemd_services.txt" ]; then
  echo -e "enabling system service"
  while IFS= read -r service || [ -n "$service"]; do
    [[ -z "$service" || "$service" =~ ^#.* ]] && continue

    echo -e "enabling $service"
    sudo systemctl enable "$service" 2>/dev/null || echo -e "failed to enable $service"
  done <"$dot_dir/systemd_services.txt"
  sudo systemctl daemon-reload
fi

echo -e "Setup Complete"
