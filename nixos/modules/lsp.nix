{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    # gnu and c
    gcc
    gnumake
    clang-tools

    # rust
    cargo
    rustc

    # golang
    go
    templ

    # js
    nodejs

    # nix
    nil
    nixfmt
  ];
}
