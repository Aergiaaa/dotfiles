{ pkgs, self }:
pkgs.dwm.overrideAttrs (old: {
  src = self + "/dwm";
})
