# modules/home-canvas.nix
{
  config,
  pkgs,
  lib,
  ...
}:

let
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
  # Configurações do home-manager (NÃO use environment.systemPackages aqui)
  home.sessionVariables = {
    LD_LIBRARY_PATH = "${libraryPath}:/run/current-system/sw/lib";
  };

  programs.bash = {
    bashrcExtra = ''
      export LD_LIBRARY_PATH="${libraryPath}:/run/current-system/sw/lib:$LD_LIBRARY_PATH"
    '';
    profileExtra = ''
      export LD_LIBRARY_PATH="${libraryPath}:/run/current-system/sw/lib:$LD_LIBRARY_PATH"
    '';
  };
}
