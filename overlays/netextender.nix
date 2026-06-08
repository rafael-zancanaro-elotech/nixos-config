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

            # Script wrapper para adicionar rota automaticamente
            cat > $out/bin/netextender-connect << 'WRAPPER'
      #!/bin/bash
      # Executa a conexão
      $out/netextender/nxcli connect "$@" &
      PID=$!
      sleep 5
      if ip link show ppp0 2>/dev/null; then
        ip route add default dev ppp0 2>/dev/null
      fi
      wait $PID
      WRAPPER
            chmod +x $out/bin/netextender-connect
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
        libsoup_3
        libsecret
        libnotify
        libxslt
        libxml2
      ];

    runScript = ''
      # Verificar se a porta está livre
      if lsof -i :51330 > /dev/null 2>&1; then
        sudo kill -9 $(sudo lsof -t -i:51330) 2>/dev/null
        sleep 2
      fi

      # Iniciar o serviço
      if ! pgrep -f NEService > /dev/null; then
        ${extracted}/netextender/NEService &
        sleep 3
      fi

      # Executar o comando
      case "$1" in
        --gui|-g)
          shift
          export GDK_BACKEND=x11
          exec ${extracted}/netextender/NetExtender_webkit2_41 "$@"
          ;;
        connect)
          shift
          exec ${extracted}/netextender/nxcli connect "$@" && \
            sleep 5 && ip route add default dev ppp0 2>/dev/null
          ;;
        *)
          exec ${extracted}/netextender/nxcli "$@"
          ;;
      esac
    '';
  };
}
