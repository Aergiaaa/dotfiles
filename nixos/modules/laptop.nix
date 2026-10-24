{ ... }:
{
  services.asusd.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";
}
