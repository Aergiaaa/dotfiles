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
    rustfmt
    rust-analyzer
    clippy
    rustPlatform.rustLibSrc

    # golang
    go
    gopls
    templ

    # js
    nodejs
    bun

    # php
    php84
    php84Packages.composer
    phpantom-lsp

    # zig
    zig
    zls

    # nix
    nil
    nixfmt

    # lua
    lua-language-server

    # bash
    bash-language-server
		shfmt

    # html & css
    emmet-language-server
    tailwindcss-language-server
    typescript-language-server
    vue-language-server
		prettier

    # python
  ];

  environment.variables.RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
}
