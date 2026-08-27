{ pkgs, ... }:
let
	falloutTheme = pkgs.fetchFromGitHub {
		owner = "shvchk";
		repo = "fallout-grub-theme";
		rev = "b441e25a6d115614dc00ee6d11355d019a4969bf";
		hash = "sha256-dNRLM9tQjWOyi3s4Q2er5Xn2bpG/yQ/D/+F/lfYXrs8=";
	};
in
{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
		configurationLimit = 10;
		copyKernels = false; # keeping kernel in /nix/store
		theme = falloutTheme;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
}
