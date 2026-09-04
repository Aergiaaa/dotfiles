{ pkgs, libxcursor, libx11, libxinerama, libxft, fontconfig, self }:

pkgs.dwm.overrideAttrs (old: {
  src = self + "/dwm";
  buildInputs = [ libxcursor libx11 libxinerama libxft fontconfig ];
})
