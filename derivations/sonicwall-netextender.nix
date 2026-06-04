{
  stdenv,
  fetchurl,
  ppp,
  zlib,
  openjdk,
  lib,
  writeShellScriptBin,
}:

let
  version = "10.3.5-36";
  sha256 = "iFgvqW+x3fKHaDvDZqcZil4+bs3Edz35E236Pkk9o4Y";

  # Importar buildFHSUserEnv do pkgs
  pkgs = import <nixpkgs> { };
  buildFHSUserEnv = pkgs.buildFHSUserEnv;

  src = fetchurl {
    url = "https://software.sonicwall.com/NetExtender/NetExtender-linux-amd64-${version}.tar.gz";
    inherit sha256;
  };

  # Extrair os arquivos do NetExtender
  extracted = stdenv.mkDerivation {
    name = "netextender-${version}-extracted";
    inherit src;

    installPhase = ''
      mkdir -p $out
      tar xzf $src -C $out
      chmod -R u+w $out
      ls -la $out
    '';
  };

  # Criar o ambiente FHS com o NetExtender
  netextender-env = buildFHSUserEnv {
    name = "netextender-${version}-env";

    targetPkgs =
      pkgs: with pkgs; [
        ppp
        zlib
        openjdk
        stdenv.cc.cc.lib
        libpcap
        xorg.libX11
        xorg.libXext
        xorg.libXtst
        xorg.libXi
      ];

    runScript = writeShellScriptBin "run-netextender" ''
      echo "Procurando NetExtender em: ${extracted}"
      ls -la ${extracted}

      # Encontrar o executável do NetExtender
      if [ -f "${extracted}/NetExtender/bin/netExtender" ]; then
        echo "Executando NetExtender..."
        exec "${extracted}/NetExtender/bin/netExtender" "$@"
      elif [ -f "${extracted}/netExtender" ]; then
        echo "Executando NetExtender..."
        exec "${extracted}/netExtender" "$@"
      else
        echo "Erro: Não encontrou o executável do NetExtender"
        echo "Buscando em toda a árvore:"
        find ${extracted} -name "netExtender" -o -name "NetExtender" -type f 2>/dev/null
        exit 1
      fi
    '';
  };

in
stdenv.mkDerivation {
  name = "netextender-${version}";

  buildInputs = [ netextender-env ];

  installPhase = ''
    mkdir -p $out/bin

    # Criar um wrapper simples
    cat > $out/bin/netextender << EOF
    #!${stdenv.shell}
    exec ${netextender-env}/bin/run-netextender "\$@"
    EOF

    chmod +x $out/bin/netextender
  '';

  meta = with lib; {
    description = "SonicWall NetExtender VPN client";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}
