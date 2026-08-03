{ pkgs, libx11, libxext, libxcrypt, libxrandr, libxinerama, imlib2 }:

pkgs.slock.overrideAttrs (old: {
  src = /home/aergia/dotfiles/slock;
  buildInputs = [ libx11 libxext libxcrypt libxrandr libxinerama imlib2 ];
})
