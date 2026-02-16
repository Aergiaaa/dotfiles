#!/bin/bash

set -e

cd ~/dotfiles

echo "syncing saved dotfiles"
DOTFILES=(
  ".zshrc"
  ".p10k.zsh"
  ".tmux.conf"
  ".xinitrc"
  ".zscript"
  ".config"
  ".oh-my-zsh"
  ".tmux"
  ".ssh"
  ".pki"
  ".steam"
)

for item in "${DOTFILES[@]}"; do
  if [ -e "$HOME/$item" ]; then
    if [ -L "$HOME/$item" ]; then
      echo "$item already in sync"
    else
      echo "-> copying $item"
      rsync -a --delete "$HOME/$item" .
    fi
  else
    echo "$item not found in $HOME dir"
  fi
done

echo "backing up packages"
pacman -Qqen >pkglist.txt
pacman -Qqem >pkglist_aur.txt

echo "uploading changes to git"
git add -A

echo "commiting changes"
git commit -m "updating dotfiles and packages - $(date +%Y-%m-%d\ %H:%M:%S)" || echo "no changes to commit"

echo "pushing to remote"
if git push; then
  echo "pushed to remote"
else
  "failed to push"
fi

echo "backup complete"
