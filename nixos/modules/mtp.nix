{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fuse
    go-mtpfs
  ];
}
