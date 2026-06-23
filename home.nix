{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Lista de bibliotecas
  canvasLibraries = with pkgs; [
    util-linux
    libuuid
    glib
    gtk3
    libGL
    libx11
    libxext
    libxtst
    libxi
    libxrender
    libxcb
    libxkbcommon
    dbus
    fontconfig
    freetype
    cairo
    pango
    gdk-pixbuf
    atk
  ];

  libraryPath = lib.makeSearchPath "lib" canvasLibraries;
in
{
  home.username = "zancanaro";
  home.homeDirectory = "/home/zancanaro";

  imports = [
    ./modules/code-and-ide.nix
    ./modules/social.nix
    ./modules/misc.nix
    ./modules/home-canvas.nix
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

  # ===== CONFIGURAÇÃO DO BASH =====
  programs.bash = {
    enable = true;

    # Isso vai gerar o ~/.bashrc
    bashrcExtra = ''
      # LD_LIBRARY_PATH para as bibliotecas do canvas
      export LD_LIBRARY_PATH="${libraryPath}:/run/current-system/sw/lib:$LD_LIBRARY_PATH"

      # Aliases
      alias ll='ls -la'
      alias la='ls -A'
    '';
  };

  # Também configurar o profile para login shells
  programs.bash.profileExtra = ''
    export LD_LIBRARY_PATH="${libraryPath}:/run/current-system/sw/lib:$LD_LIBRARY_PATH"
  '';

  # Fallback: forçar a criação do arquivo
  home.file.".bashrc" = {
    text = ''
      # ~/.bashrc - Gerado pelo home-manager
      export LD_LIBRARY_PATH="${libraryPath}:/run/current-system/sw/lib:$LD_LIBRARY_PATH"

      if [ -f /etc/bashrc ]; then
        . /etc/bashrc
      fi
    '';
  };

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${libraryPath}:/run/current-system/sw/lib";
  };
}
