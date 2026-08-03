{ pkgs, ... }:
let
	suckless = pkgs.lib.mapAttrs (name: _: pkgs.callPackage /etc/nixos/pkgs/${name} { })
		(builtins.readDir /etc/nixos/pkgs);
in
{
	services = {
		getty.autologinUser = "aergia";
		input-remapper.enable = true;
	};

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

	# security.wrappers.slock = {
	# 	owner = "root";                                                                                                 
	#   group = "root";                                                                                                 
	#   capabilities = "cap_sys_resource+ep";                                                                           
	#   source = "${suckless.slock}/bin/slock";                                                                         
	# };
	programs.slock = {
		enable = true;
		package = suckless.slock;
	};

	environment.systemPackages = 
			builtins.attrValues (builtins.removeAttrs suckless [ "slock" ]) 
			++ (with pkgs; [
				btop radeontop lm_sensors
				rmpc mpd
				git gh wget
				qutebrowser discord
				fastfetch 
				xclip scrot dunst
				picom feh fzf xrdb
				fd
				gnome-keyring 
  ]);
}
