{ pkgs, lib, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
    ];
  };

	virtualisation.docker.enable = true;
	users.users.aergia.extraGroups = [ "docker" ];
	systemd.services.docker.wantedBy = lib.mkForce [];

	services.postgresql.enable = false;

  environment.systemPackages = with pkgs; [
		file unzip

		openssl

    neovim bob-nvim neovim-remote

		gcc gnumake clang-tools

    go gopls templ

		sqlc

		redis postgresql

		ripgrep

		lua-language-server bash-language-server shfmt

		rust-analyzer

		nodejs
		typescript-language-server tailwindcss-language-server emmet-language-server
		prettier

		ruff pyright
  ];
}
