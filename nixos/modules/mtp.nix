{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [ fuse3 simple-mtpfs ];
}
