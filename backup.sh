#!/bin/bash

set -e

cd $HOME/dotfiles

echo "syncing saved dotfiles"

EXCLUDE_PATTERN=(
  # Browser data
  "--exclude=BraveSoftware"
  "--exclude=google-chrome"
  "--exclude=chromium"

  # Code editors
  "--exclude=VSCodium/Cache"
  "--exclude=VSCodium/CachedData"
  "--exclude=VSCodium/Code Cache"
  "--exclude=VSCodium/GPUCache"
  "--exclude=VSCodium/logs"

  # Apps
  "--exclude=discord/Cache"
  "--exclude=discord/Code Cache"
  "--exclude=discord/GPUCache"

  # Generic cache patterns
  "--exclude=*cache"
  "--exclude=*Cache"
  "--exclude=CachedData"
  "--exclude=GPUCache"
  "--exclude=Code Cache"

  # Logs
  "--exclude=*.log"
  "--exclude=logs"

  # Build artifacts
  "--exclude=node_modules"
)

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

echo "removing .git from packages"
find . -path ./.git -prune -o -type d -name .git -print | while read -r gitdir; do
  echo "removing $gitdir"
  rm -rf "$gitdir"
  echo "removed $gitdir"
done

echo "backing up packages"
pacman -Qqen >pkglist.txt
pacman -Qqem >pkglist_aur.txt

echo "dotfile size:"
du -sh ~/dotfiles 2>/dev/null || echo "cannot calculate sizes"

echo "status:"
git status --short

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
