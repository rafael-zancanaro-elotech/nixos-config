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

      # Configuração do nixpkgs (moveu o allowUnfree para cá)
      pkgsConfig = {
        allowUnfree = true;
      };

      # Overlay com pacotes customizados
      customOverlay = final: prev: {
        netextender = final.callPackage ./derivations/sonicwall-netextender.nix { };
      };

      # Cria a instância do pkgs com a configuração e overlay
      pkgs = import nixpkgs {
        inherit system;
        config = pkgsConfig;
        overlays = [ customOverlay ];
      };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit pkgs;
          };

          modules = [
            ./configuration.nix

            # Passar o pkgs configurado para o sistema
            {
              nixpkgs.pkgs = pkgs;
            }

            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zancanaro =
                { config, ... }:
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
