{ pkgs, ... }:
{
  programs.zsh.enable = true;

  users.users = {
    aergia = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
    };

    away = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
