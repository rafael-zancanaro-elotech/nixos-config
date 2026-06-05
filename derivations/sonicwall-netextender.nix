{
  stdenv,
  fetchurl,
  buildFHSEnv,
  ppp,
  zlib,
  openjdk,
  lib,
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
    buildInputs = [ ];
    installPhase = ''
      mkdir -p $out
      tar xzf $src -C $out
      # Garantir permissões de execução durante a extração
      chmod -R 755 $out/netextender
      # Verificar se os binários estão executáveis
      test -x $out/netextender/neservice || echo "ERRO: neservice não está executável"
      test -x $out/netextender/nxcli || echo "ERRO: nxcli não está executável"
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

  meta = with lib; {
    description = "SonicWall NetExtender VPN client";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}
