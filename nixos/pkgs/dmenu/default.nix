{ pkgs }:
pkgs.dmenu.overrideAttrs (old: {
  src = /home/aergia/dotfiles/dmenu;
})
