{ pkgs, lib, ... }:
{
  documentation.man.cache.enable = true;

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

    # tree sitter
    tree-sitter

    # ssl
    openssl

    # nvim
    neovim
    bob-nvim
    neovim-remote

    # db
    redis
    postgresql
    sqlc
    sqlite

    # grep
    ripgrep

    # python cmd
    python3
  ];

  # PBPhp
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    ensureDatabases = [ "uin_db" ];
    ensureUsers = [
      {
        name = "appuser";
        ensurePermissions = {
          "uin_db.*" = "ALL PRIVILEGES";
        };
      }
    ];

    # Optional: initial SQL script (runs once on first start)
    initialScript = pkgs.writeText "init.sql" ''
      CREATE DATABASE IF NOT EXISTS myapp;
      CREATE USER IF NOT EXISTS 'appuser'@'localhost' IDENTIFIED BY 'secret';
      GRANT ALL PRIVILEGES ON myapp.* TO 'appuser'@'localhost';
      FLUSH PRIVILEGES;
    '';
  };
  systemd.services.mysql.wantedBy = lib.mkForce [ ];
}
