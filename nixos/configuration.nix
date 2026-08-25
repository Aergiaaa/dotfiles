{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
			./modules/boot.nix
			./modules/networking.nix
			./modules/audio.nix
			./modules/users.nix
			./modules/dev-pkgs.nix
			./modules/desktop.nix
			./modules/wm.nix
			./modules/color.nix
			./modules/game.nix
			./modules/ai.nix
			./modules/mtp.nix
			./modules/option.nix
    ];

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";

	environment.sessionVariables.PATH = [ "$HOME/dotfiles/script" ];

	nixpkgs.config.allowUnfree = true;

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}

