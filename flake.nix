{
  description = "TYSONCLOUD Server Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }:
    {
      nixosConfigurations.tysoncloud-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./tysoncloud.nix
        ];
      };
    };
}
