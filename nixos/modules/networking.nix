{ ... }:
{
  networking = {
    hostName = "lighthouse";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "wlp1s0" ];
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  services.openssh.enable = true;

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
