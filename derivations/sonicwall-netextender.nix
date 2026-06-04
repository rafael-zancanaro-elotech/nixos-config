{
  stdenv,
  fetchurl,
  buildFHSUserEnv,
  ppp,
  zlib,
  openjdk,
  lib,
  writeShellScriptBin,
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

  runScript = writeShellScriptBin "netextender" ''
    echo "NetExtender wrapper iniciado..."
    echo "Procurando executável em: ${extracted}"

    # Tenta encontrar o executável
    if [ -f "${extracted}/NetExtender/bin/netExtender" ]; then
      echo "Executando NetExtender..."
      exec "${extracted}/NetExtender/bin/netExtender" "$@"
    elif [ -f "${extracted}/netExtender" ]; then
      echo "Executando NetExtender..."
      exec "${extracted}/netExtender" "$@"
    else
      echo "Erro: NetExtender não encontrado!"
      echo "Estrutura do diretório extraído:"
      find ${extracted} -type f -name "netExtender" -o -name "*.sh" -o -name "install" 2>/dev/null | head -20
      exit 1
    fi
  '';
}
