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

      # Overlay com pacotes customizados
      customOverlay = final: prev: {
        netextender = final.callPackage ./derivations/sonicwall-netextender.nix { };
        # Se tiver outros pacotes customizados no futuro, adicione aqui
      };

      # Aplica o overlay ao nixpkgs
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ customOverlay ];
      };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          # Importante: usar os pkgs com overlay
          modules = [
            ./configuration.nix

            home-manager.nixosModules.home-manager

            {
              # Usar os pkgs com overlay
              nixpkgs.pkgs = pkgs;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.zancanaro =
                { config, ... }:
                {
                  imports = [ ./home.nix ];

                  # Adicionar o NetExtender aos pacotes do usuário
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
