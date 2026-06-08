{
  stdenv,
  fetchurl,
  buildFHSEnv,
  ppp,
  zlib,
  openjdk,
  webkitgtk_4_1,
  glib,
  gtk3,
  gdk-pixbuf,
  pango,
  cairo,
  atk,
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
  libsoup_3,
  libsecret,
  libnotify,
  libxslt,
  libxml2,
  gst_all_1,
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
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
    ];

  runScript = ''
    # Criar link para o serviço (fora do FHS)
    if [ ! -f /run/current-system/sw/bin/nxservice ]; then
      ln -sf ${extracted}/netextender/NEService /run/current-system/sw/bin/nxservice 2>/dev/null || true
    fi

    # Iniciar o serviço via systemd
    systemctl start netextender 2>/dev/null || true

    # Executar o comando solicitado
    case "$1" in
      --gui|-g)
        shift
        export GDK_BACKEND=x11
        exec ${extracted}/netextender/NetExtender_webkit2_41 "$@"
        ;;
      connect|disconnect|status|about|cert|connection|log|proxy|settings)
        exec ${extracted}/netextender/nxcli "$@"
        ;;
      "")
        exec ${extracted}/netextender/nxcli
        ;;
      *)
        exec ${extracted}/netextender/nxcli "$@"
        ;;
    esac
  '';
}
