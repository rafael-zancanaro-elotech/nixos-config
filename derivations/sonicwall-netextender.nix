{
  stdenv,
  fetchurl,
  ppp,
  zlib,
  openjdk,
  buildFHSEnv,
  glib,
  gtk3,
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
      chmod -R +w $out
      # Mover os arquivos do subdiretório netextender para o root
      mv $out/netextender/* $out/
      rmdir $out/netextender
      chmod +x $out/nxcli $out/NetExtender_webkit2_41 $out/neservice
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
      glib
      gtk3
      libGL
      xorg.libX11
      xorg.libXext
      xorg.libXtst
      xorg.libXi
      xorg.libXrender
      xorg.libxcb
      libxkbcommon
      dbus
      fontconfig
      freetype
    ];

  runScript = ''
    echo "Iniciando NetExtender..."
    cd ${extracted}
    export LD_LIBRARY_PATH=${extracted}:$LD_LIBRARY_PATH
    exec ${extracted}/NetExtender_webkit2_41 "$@"
  '';
}
