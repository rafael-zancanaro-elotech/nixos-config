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
      home-manager,
      pkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

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
        jaspersoft-studio = jaspersoft-studio;
      };

      nixosConfigurations = {
        nixos = pkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager

            {
              # Usar o pkgs com overlays
              nixpkgs.pkgs = pkgs;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zancanaro = { pkgs, ... }: {
                imports = [ ./home.nix ];
                home.packages = with pkgs; [
                  jaspersoft-studio
                ];
              };
            }
          ];
        };
      };
    };
}
