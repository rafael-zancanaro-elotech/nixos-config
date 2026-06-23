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
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager

            {
              # Sem nixpkgs.config aqui
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.zancanaro = { config, pkgs, ... }: {
                imports = [ ./home.nix ];

                # REMOVA esta linha também
                # nixpkgs.config.allowUnfree = true;

                home.packages = with pkgs; [
                  (pkgs.callPackage ./derivations/jaspersoft-studio.nix {
                    inherit (pkgs)
                      gsettings-desktop-schemas
                      gtk3
                      glib
                      glib-networking
                      ;
                  })
                ];
              };
            }
          ];
        };
      };
    };
}
