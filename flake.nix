{
  description = "Configuração do PC Elotech";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Overlay do NetExtender
    netextender = {
      url = "github:irlnuisance/netextender-nix-overlay";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      netextender,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Criar pkgs com o overlay do NetExtender
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          netextender.overlays.${system}
        ];
      };

      # Seu Jaspersoft Studio continua manual
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
              # Passar o pkgs com overlay
              nixpkgs.pkgs = pkgs;

              # Adicionar netextender aos pacotes do sistema
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
