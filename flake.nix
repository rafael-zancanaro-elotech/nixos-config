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
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      netextender = pkgs.callPackage ./derivations/sonicwall-netextender.nix { };
    in
    {
      packages.${system} = {
        inherit netextender;
      };

      defaultPackage.${system} = netextender;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
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
