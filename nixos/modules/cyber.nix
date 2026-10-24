{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    burpsuite
    ffuf
  ];

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };
}
