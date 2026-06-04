{
  description = "Configuração do PC Elotech";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./configuration.nix

            # Overlay para adicionar o netextender
            {
              nixpkgs.overlays = [
                (final: prev: {
                  netextender = final.callPackage ./derivations/sonicwall-netextender.nix { };
                })
              ];
            }

            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zancanaro =
                { config, pkgs, ... }:
                {
                  imports = [ ./home.nix ];
                  home.packages = with pkgs; [
                    netextender
                  ];
                };
            }
          ];
        };
      };
    };
}
