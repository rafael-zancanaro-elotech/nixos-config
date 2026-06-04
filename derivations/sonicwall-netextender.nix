{
  stdenv,
  fetchurl,
  buildFHSUserEnv,
  ppp,
  zlib,
  openjdk,
  writeShellScriptBin,
  lib,
}:

let
  version = "10.3.5-36";
  sha256 = "iFgvqW+x3fKHaDvDZqcZil4+bs3Edz35E236Pkk9o4Y";

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
        # Bibliotecas adicionais que podem ser necessárias
        libpcap
        xorg.libX11
        xorg.libXext
        xorg.libXtst
        xorg.libXi
      ];

    runScript = writeShellScriptBin "run-netextender" ''
      # Encontrar o executável do NetExtender
      if [ -f "${extracted}/NetExtender/bin/netExtender" ]; then
        exec "${extracted}/NetExtender/bin/netExtender" "$@"
      elif [ -f "${extracted}/netExtender" ]; then
        exec "${extracted}/netExtender" "$@"
      else
        echo "Erro: Não encontrou o executável do NetExtender"
        echo "Procurando em: ${extracted}"
        find ${extracted} -name "netExtender" -type f 2>/dev/null
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
