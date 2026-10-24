{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
		wireguard-ui
  ];
}
