{
  stdenv,
  buildFHSEnv,
  lib,
  zlib,
  libXext,
  libXrender,
  libXtst,
  gtk3,
  alsa-lib,
  fontconfig,
  dbus,
  glib,
  freetype,
  writeShellScriptBin,
}:

let
  version = "6.21.5";
  pname = "jaspersoft-studio";
  executable = "$HOME/.local/opt/js-studiocomm_${version}/Jaspersoft Studio";

  # Criar o ambiente FHS
  fhsEnv = buildFHSEnv {
    name = "${pname}-${version}-env";

    targetPkgs =
      pkgs: with pkgs; [
        zlib
        libXext
        libXrender
        libXtst
        gtk3
        alsa-lib
        fontconfig
        dbus
        glib
        freetype
        stdenv.cc.cc.lib
      ];

    # Usar aspas para lidar com espaço no caminho
    runScript = writeShellScriptBin "run-jaspersoft" ''
      exec "${executable}" "$@"
    '';
  };

in
writeShellScriptBin "jaspersoft-studio" ''
  exec ${fhsEnv}/bin/run-jaspersoft "$@"
''
