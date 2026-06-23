{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "zancanaro";
  home.homeDirectory = "/home/zancanaro";
  imports = [
    ./modules/code-and-ide.nix
    ./modules/social.nix
    ./modules/misc.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. Do not change this without reading the release notes.
  home.stateVersion = "26.05"; # Match to your release version

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Define packages you want installed in your user environment
  home.packages = with pkgs; [
    git
    helix
    ripgrep
    bat
    glow
    btop
  ];

  # Example: configure git directly via home-manager
  programs.git = {
    enable = true;
    userName = "Rafael Monteiro Zancanaro";
    userEmail = "rafael.zancanaro@elotech.com.br";
  };

  home.sessionVariables = {
    LD_LIBRARY_PATH = "/nix/store/1scb6xccxlqy8rj9hfgf7ppqv99pfwq9-util-linux-minimal-2.42-lib/lib:/nix/store/gf6i4cbisapj28y2dnqhpk1s95vd2r36-util-linux-2.42-lib/lib:${pkgs.glib}/lib:${pkgs.gtk3}/lib:${pkgs.libGL}/lib:${pkgs.libx11}/lib:${pkgs.libxext}/lib:${pkgs.libxtst}/lib:${pkgs.libxi}/lib:${pkgs.libxrender}/lib:${pkgs.libxcb}/lib:${pkgs.libxkbcommon}/lib:${pkgs.dbus}/lib:${pkgs.fontconfig}/lib:${pkgs.freetype}/lib:/run/current-system/sw/lib";
  };
}
