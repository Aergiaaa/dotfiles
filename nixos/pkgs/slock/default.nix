{ pkgs, libx11, libxext, libxcrypt, libxrandr, libxinerama, imlib2, self }:

pkgs.slock.overrideAttrs (old: {
  src = self + "/slock";
  buildInputs = [ libx11 libxext libxcrypt libxrandr libxinerama imlib2 ];
})
