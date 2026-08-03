{ pkgs }:
pkgs.st.overrideAttrs (old: {
  src = /home/aergia/dotfiles/st;
})
