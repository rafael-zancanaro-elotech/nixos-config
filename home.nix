{ pkgs, ... }:
{
  home.username = "zancanaro";
  home.homeDirectory = "/home/zancanaro";

  imports = [
    ./modules/code-and-ide.nix
    ./modules/social.nix
    ./modules/misc.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    helix
    ripgrep
    bat
    glow
    btop
    jq
    xournalpp
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Rafael Monteiro Zancanaro";
        email = "rafael.zancanaro@elotech.com.br";
      };
    };
  };

  home.file.".bashrc".source = ./dotfiles/bash_aliases;
}
