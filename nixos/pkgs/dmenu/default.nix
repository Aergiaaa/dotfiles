{ pkgs, self}:
pkgs.dmenu.overrideAttrs (old: {
  src = self + "/dmenu";
})
