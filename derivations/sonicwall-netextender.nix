{
  stdenv,
  fetchurl,
  ppp,
  zlib,
  openjdk,
  buildFHSEnv,
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
      chmod -R +w $out
      echo "Extraído para: $out"
      ls -la $out/NetExtender/bin/
    '';
  };

  # Criar o ambiente FHS
  fhsEnv = buildFHSEnv {
    name = "netextender-fhs";
    targetPkgs =
      pkgs: with pkgs; [
        ppp
        zlib
        openjdk
        stdenv.cc.cc.lib
      ];
    runScript = "netextender-real";
  };

  # Criar o script real que será executado dentro do FHS
  realScript = writeShellScriptBin "netextender-real" ''
    export PATH=${stdenv.cc.cc.lib}/lib:$PATH
    export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib:${zlib}/lib:${openjdk}/lib:${ppp}/lib:$LD_LIBRARY_PATH

    echo "Iniciando NetExtender..."
    exec ${extracted}/NetExtender/bin/netExtender "$@"
  '';

in
stdenv.mkDerivation {
  name = "netextender-${version}";

  buildInputs = [
    fhsEnv
    realScript
  ];

  installPhase = ''
    mkdir -p $out/bin

    # Wrapper principal
    cat > $out/bin/netextender << EOF
    #!${stdenv.shell}
    exec ${fhsEnv}/bin/netextender-fhs "\$@"
    EOF

    chmod +x $out/bin/netextender
  '';
}
