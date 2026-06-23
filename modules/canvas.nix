# modules/canvas.nix
{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Lista de bibliotecas necessárias
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

  # Caminho do nix-ld dinâmico
  nixLdPath = "${pkgs.nix-ld}/share/nix-ld/lib";

  # Path para as bibliotecas
  libraryPath = lib.makeSearchPath "lib" canvasLibraries;
in
{
  # ===== CONFIGURAÇÕES DO SISTEMA (para configuration.nix) =====
  config = lib.mkIf (builtins.hasAttr "nix-ld" config) {
    programs.nix-ld = {
      enable = true;
      libraries = canvasLibraries;
    };

    environment.systemPackages = canvasLibraries;
  };

  # ===== CONFIGURAÇÕES DO HOME-MANAGER (para home.nix) =====
  home = lib.mkIf (builtins.hasAttr "home" config) {
    sessionVariables = {
      LD_LIBRARY_PATH = "${nixLdPath}:${libraryPath}:/run/current-system/sw/lib";
    };
  };

  # Configuração do bash (funciona em ambos)
  programs.bash = lib.mkIf (builtins.hasAttr "home" config) {
    bashrcExtra = ''
      # Adicionar caminho do nix-ld para encontrar libuuid
      export LD_LIBRARY_PATH="${nixLdPath}:${libraryPath}:/run/current-system/sw/lib:$LD_LIBRARY_PATH"
    '';
    profileExtra = ''
      export LD_LIBRARY_PATH="${nixLdPath}:${libraryPath}:/run/current-system/sw/lib:$LD_LIBRARY_PATH"
    '';
  };
}
