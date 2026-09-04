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
  systemd.services.docker.wantedBy = lib.mkForce [ ];

  services.postgresql.enable = false;

  environment.systemPackages = with pkgs; [
    # file shit
    file
    unzip

    # ssl
    openssl

    # nvim
    neovim
    bob-nvim
    neovim-remote

    # gnu and c
    gcc
    gnumake
    clang-tools

    # rust
    cargo

    # golang
    go
    templ

    # db
    redis
    postgresql
    sqlc

    # grep
    ripgrep

    # js
    nodejs

    # nix
    nil
    nixfmt
  ];
}
