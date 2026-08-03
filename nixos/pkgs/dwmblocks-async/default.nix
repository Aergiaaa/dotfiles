{ lib, stdenv, pkg-config, libxcb, libxcb-util }:

stdenv.mkDerivation	{
	pname = "dwmblocks-async";
	version = "local";

	src = /home/aergia/dotfiles/dwmblocks-async;

	nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxcb libxcb-util ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/dwmblocks $out/bin/
  '';
}
