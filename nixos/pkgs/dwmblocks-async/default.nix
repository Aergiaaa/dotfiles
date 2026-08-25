{ lib, stdenv, pkg-config, libxcb, libxcb-util, self ? null }:

stdenv.mkDerivation	{
	pname = "dwmblocks-async";
	version = "local";

	src = self + "/dwmblocks-async";

	nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxcb libxcb-util ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/dwmblocks $out/bin/
  '';
}
