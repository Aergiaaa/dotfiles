{ pkgs, self, ... }:
let
	suckless = pkgs.lib.mapAttrs (name: _: pkgs.callPackage ../pkgs/${name} { inherit self; })
		(builtins.readDir ../pkgs);
in
{
	services = {
		getty.autologinUser = "aergia";
		input-remapper.enable = true;
	};

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

	programs.slock = {
		enable = true;
		package = suckless.slock;
	};

	environment.systemPackages = 
			builtins.attrValues (builtins.removeAttrs suckless [ "slock" ]) 
			++ (with pkgs; [
				ffmpeg-full

				btop radeontop lm_sensors
				rmpc mpd
				libnotify
				git gh wget
				qutebrowser chromium discord
				fastfetch zathura
				xclip scrot dunst
				picom feh fzf xrdb
				fd
				gnome-keyring 
  ]);
}
