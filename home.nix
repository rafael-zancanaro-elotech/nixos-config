{ config, pkgs, ... }:
{
  home.username = "zancanaro";
  home.homeDirectory = "/home/zancanaro";

  imports = [
    ./modules/code-and-ide.nix
    ./modules/social.nix
    ./modules/misc.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    helix
    ripgrep
    bat
    glow
    btop
  ];

  programs.git = {
    enable = true;
    userName = "Rafael Monteiro Zancanaro";
    userEmail = "rafael.zancanaro@elotech.com.br";
  };

  # ===== ÚNICA COISA QUE PRECISA =====
  # Configurar o bash para ter o LD_LIBRARY_PATH
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export LD_LIBRARY_PATH="/run/current-system/sw/lib:$LD_LIBRARY_PATH"
    '';
  };

  # Também para login shells
  programs.bash.profileExtra = ''
    export LD_LIBRARY_PATH="/run/current-system/sw/lib:$LD_LIBRARY_PATH"
  '';
}
