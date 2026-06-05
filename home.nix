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
  ];

  # Example: configure git directly via home-manager
  programs.git = {
    enable = true;
    userName = "Rafael Monteiro Zancanaro";
    userEmail = "rafael.zancanaro@elotech.com.br";
  };

  home.shellAliases = {
    nx = "netextender --gui";
    nx-connect = "netextender connect";
    nx-status = "netextender status";
    nx-disconnect = "netextender disconnect";
  };
}
