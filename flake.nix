{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      freesmlauncher,
      ...
    }:
    {
      nixosConfigurations.lighthouse = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit self freesmlauncher; }; # expose repo

        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
}
