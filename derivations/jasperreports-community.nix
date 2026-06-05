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
}:

let
  version = "6.21.5";
  pname = "jaspersoft-studio";

in
buildFHSEnv {
  name = "${pname}-${version}";

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

  runScript = "$HOME/.local/opt/js-studiocomm_${version}/Jaspersoft Studio";

  meta = with lib; {
    description = "Jaspersoft Studio Community Edition - Report Designer";
    platforms = [ "x86_64-linux" ];
  };
}
