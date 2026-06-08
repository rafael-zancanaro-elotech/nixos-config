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

      # Importar overlays locais
      netextenderOverlay = import ./overlays/netextender.nix;

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          netextenderOverlay
        ];
      };

      # Seu Jaspersoft Studio
      jaspersoft-studio = pkgs.callPackage ./derivations/jaspersoft-studio.nix {
        inherit (pkgs)
          gsettings-desktop-schemas
          gtk3
          glib
          glib-networking
          ;
      };

    in
    {
      packages.${system} = {
        netextender = pkgs.netextender;
        jaspersoft-studio = jaspersoft-studio;
      };

      defaultPackage.${system} = pkgs.netextender;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager

            {
              # Usar o pkgs com overlays
              nixpkgs.pkgs = pkgs;

              # Adicionar ao sistema
              environment.systemPackages = with pkgs; [
                netextender
              ];

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zancanaro = { config, pkgs, ... }: {
                imports = [ ./home.nix ];
                home.packages = with pkgs; [
                  netextender
                  jaspersoft-studio
                ];
              };
            }
          ];
        };
      };
    };
}
