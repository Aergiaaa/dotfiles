{ pkgs, ... }:
let
	suckless = pkgs.lib.mapAttrs (name: _: pkgs.callPackage /etc/nixos/pkgs/${name} { })
		(builtins.readDir /etc/nixos/pkgs);
in
{
	services = {
		xserver = {
			enable = true;
			displayManager.startx.enable = true;

			windowManager.dwm = {
				enable = true;
				package = suckless.dwm;
			};
		};

		libinput = {
			enable = true;
			mouse.naturalScrolling = false;
			touchpad.naturalScrolling = true;
		};
	};

	environment.systemPackages = with pkgs; [
		brightnessctl
	];
}
