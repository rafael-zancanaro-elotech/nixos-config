{
  stdenv,
  fetchurl,
  ppp,
  zlib,
  openjdk,
  lib,
  writeShellScriptBin,
  buildFHSUserEnv,
}:

let
  version = "10.3.5-36";
  sha256 = "iFgvqW+x3fKHaDvDZqcZil4+bs3Edz35E236Pkk9o4Y";

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
      chmod -R u+w $out
      echo "Conteúdo extraído:"
      ls -la $out
    '';
  };

in
buildFHSUserEnv {
  name = "netextender-${version}";

  targetPkgs =
    pkgs: with pkgs; [
      ppp
      zlib
      openjdk
      stdenv.cc.cc.lib
    ];

  runScript =
    "netextender"
    + writeShellScriptBin "netextender-run" ''
      echo "NetExtender wrapper iniciado..."

      if [ -f "${extracted}/NetExtender/bin/netExtender" ]; then
        echo "Executando NetExtender..."
        exec "${extracted}/NetExtender/bin/netExtender" "$@"
      elif [ -f "${extracted}/netExtender" ]; then
        echo "Executando NetExtender..."
        exec "${extracted}/netExtender" "$@"
      else
        echo "Erro: NetExtender não encontrado!"
        exit 1
      fi
    '';
}
