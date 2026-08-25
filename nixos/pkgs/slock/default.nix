{ pkgs, libx11, libxext, libxcrypt, libxrandr, libxinerama, imlib2, self ? null }:

pkgs.slock.overrideAttrs (old: {
  src = self + "/slock";
  buildInputs = [ libx11 libxext libxcrypt libxrandr libxinerama imlib2 ];
})
