{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
			/etc/nixos/modules/boot.nix
			/etc/nixos/modules/networking.nix
			/etc/nixos/modules/audio.nix
			/etc/nixos/modules/users.nix
			/etc/nixos/modules/dev-pkgs.nix
			/etc/nixos/modules/desktop.nix
			/etc/nixos/modules/wm.nix
			/etc/nixos/modules/color.nix
			/etc/nixos/modules/game.nix
			/etc/nixos/modules/ai.nix
    ];

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";

	environment.sessionVariables.PATH = [ "$HOME/dotfiles/script" ];

	nixpkgs.config.allowUnfree = true;

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}

