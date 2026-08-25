{ pkgs, self ? null }:
pkgs.dmenu.overrideAttrs (old: {
  src = self + "/dmenu";
})
