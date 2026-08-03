{ pkgs }:
pkgs.dwm.overrideAttrs (old: {
  src = /home/aergia/dotfiles/dwm;
})
