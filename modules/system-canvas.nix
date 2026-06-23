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
in
{
  # Configurações do sistema
  programs.nix-ld = {
    enable = true;
    libraries = canvasLibraries;
  };

  environment.systemPackages = canvasLibraries;
}
