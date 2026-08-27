{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
			./modules
    ];

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";

	environment.sessionVariables.PATH = [ "$HOME/dotfiles/script" ];

	nixpkgs.config.allowUnfree = true;

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}

