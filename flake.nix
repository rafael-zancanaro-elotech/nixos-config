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
      jaspersoft-studio = pkgs.callPackage ./derivations/jaspersoft-studio.nix { };
    in
    {
      packages.${system} = {
        inherit netextender jasperreports;
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
                    jaspersoft-studio
                  ];
                };
            }
          ];
        };
      };
    };
}
