{ pkgs, freesmlauncher, ... }:
{
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    gamemode

    protonup-qt

    # MC
    prismlauncher
    freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher
  ];
}
