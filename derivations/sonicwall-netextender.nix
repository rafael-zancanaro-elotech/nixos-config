{
  stdenv,
  fetchurl,
  buildFHSEnv,
  ppp,
  zlib,
  openjdk,
  lib,
  webkitgtk_4_1,
  glib,
  gtk3,
  libGL,
  libx11,
  libxext,
  libxtst,
  libxi,
  libxrender,
  libxcb,
  libxkbcommon,
  dbus,
  fontconfig,
  freetype,
}:

let
  version = "10.3.5-36";
  sha256 = "11m37m4kxykd2gwksxy4rmp3wpla36kndhrvd23z5pdidyljyn48";

  src = fetchurl {
    url = "https://software.sonicwall.com/NetExtender/NetExtender-linux-amd64-${version}.tar.gz";
    inherit sha256;
  };

  extracted = stdenv.mkDerivation {
    name = "netextender-${version}-extracted";
    inherit src;
    installPhase = ''
      mkdir -p $out
      tar xzf $src -C $out
      chmod -R 755 $out/netextender
    '';
  };

in
buildFHSEnv {
  name = "netextender";

  targetPkgs =
    pkgs: with pkgs; [
      ppp
      zlib
      openjdk
      stdenv.cc.cc.lib
      webkitgtk_4_1
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
    ];

  runScript = ''
    # Verificar se o serviço está rodando
    if ! pgrep -f "${extracted}/netextender/neservice" > /dev/null; then
      echo "Iniciando NEService..."
      ${extracted}/netextender/neservice &
      sleep 3
    fi

    # Executar a GUI do NetExtender
    echo "Iniciando NetExtender GUI..."
    exec ${extracted}/netextender/NetExtender_webkit2_41 "$@"
  '';
}
