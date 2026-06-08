{
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
        inherit netextender jaspersoft-studio;
      };

      defaultPackage.${system} = netextender;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager

            {
              # Adicionar netextender aos pacotes do sistema
              environment.systemPackages = with pkgs; [
                netextender
              ];

              # Adicionar o serviço systemd
              systemd.services.netextender = {
                description = "SonicWall NetExtender Service";
                after = [ "network.target" ];
                wantedBy = [ "multi-user.target" ];
                serviceConfig = {
                  ExecStart = "${netextender}/bin/nxservice";
                  Restart = "always";
                  RestartSec = 5;
                  Type = "simple";
                  User = "root";
                };
              };

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
