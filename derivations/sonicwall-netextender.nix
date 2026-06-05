{
  stdenv,
  fetchurl,
  writeShellScriptBin,
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
writeShellScriptBin "netextender" ''
  # Verificar se o serviço está rodando
  if ! pgrep -f "${extracted}/netextender/NEService" > /dev/null; then
    echo "Iniciando NEService (pode pedir sua senha)..."
    sudo ${extracted}/netextender/NEService &
    sleep 2
  fi

  # Executar o CLI ou GUI
  if [ "$1" = "--gui" ] || [ "$1" = "-g" ]; then
    shift
    exec ${extracted}/netextender/NetExtender_webkit2_41 "$@"
  else
    exec ${extracted}/netextender/nxcli "$@"
  fi
''
