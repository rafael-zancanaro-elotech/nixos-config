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
      packages.${system} = {
        # A definição do pacote será feita de outra forma
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager

            {
              # Configurar nixpkgs globalmente com allowUnfree
              nixpkgs.config.allowUnfree = true;

              # Usar o pkgs global com overlays se necessário
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.zancanaro = { config, pkgs, ... }: {
                imports = [ ./home.nix ];

                # Agora o pkgs já vem com allowUnfree configurado
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
