final: prev:
let
  version = "10.3.5-36";
  sha256 = "11m37m4kxykd2gwksxy4rmp3wpla36kndhrvd23z5pdidyljyn48";

  src = final.fetchurl {
    url = "https://software.sonicwall.com/NetExtender/NetExtender-linux-amd64-${version}.tar.gz";
    inherit sha256;
  };

  extracted = final.stdenv.mkDerivation {
    name = "netextender-${version}-extracted";
    inherit src;
    installPhase = ''
      mkdir -p $out
      tar xzf $src -C $out
      chmod -R 755 $out/netextender

      mkdir -p $out/bin
      ln -sf $out/netextender/nxcli $out/bin/netextender
      ln -sf $out/netextender/neservice $out/bin/neservice
      ln -sf $out/netextender/NEService $out/bin/NEService
      ln -sf $out/netextender/NetExtender_webkit2_41 $out/bin/netextender-gui
    '';
  };

in
{
  netextender = final.buildFHSEnv {
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
        gdk-pixbuf
        pango
        cairo
        atk
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
        libsoup_3 # ADICIONADO: biblioteca libsoup
        libsecret
        libnotify
        libxslt
        libxml2
      ];

    runScript = ''
      # Verificar se a porta está livre antes de iniciar
      if lsof -i :51330 > /dev/null 2>&1; then
        echo "Porta 51330 ocupada. Matando processo antigo..."
        sudo kill -9 $(sudo lsof -t -i:51330) 2>/dev/null
        sleep 2
      fi

      # Iniciar o serviço
      echo "Iniciando NEService..."
      ${extracted}/netextender/NEService &
      sleep 3

      # Executar o comando solicitado
      case "$1" in
        --gui|-g)
          shift
          export GDK_BACKEND=x11
          exec ${extracted}/netextender/NetExtender_webkit2_41 "$@"
          ;;
        *)
          exec ${extracted}/netextender/nxcli "$@"
          ;;
      esac
    '';
  };
}
