{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.lighthouse = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

			specialArgs = { inherit self; }; # expose repo

      modules = [
        ./nixos/configuration.nix
      ];
    };
  };
}
