{ pkgs, lib, ... }:

let
  libraryPaths = with pkgs; [
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

  canvasLibraries = libraryPaths;

  libraryPath = lib.makeSearchPath "lib" canvasLibraries;
in
{
  # Para usar no nix-ld (configuration.nix)
  config.nix-ld.libraries = canvasLibraries;

  # Para instalar no sistema
  config.environment.systemPackages = canvasLibraries;

  # Para as variáveis de ambiente (home.nix)
  config.home.sessionVariables.LD_LIBRARY_PATH = "${libraryPath}:/run/current-system/sw/lib";

  # Para o bashrc
  config.programs.bash.bashrcExtra = ''
    export LD_LIBRARY_PATH="${libraryPath}:/run/current-system/sw/lib:$LD_LIBRARY_PATH"
  '';
}
