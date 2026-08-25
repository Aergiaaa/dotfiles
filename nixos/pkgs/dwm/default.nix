{ pkgs, self ? null }:
pkgs.dwm.overrideAttrs (old: {
  src = self + "/dwm";
})
