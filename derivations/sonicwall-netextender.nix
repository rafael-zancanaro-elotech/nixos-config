{
  pkgs ? import <nixpkgs> { },
}:

let
  version = "10.3.5-36"; # <<< ATUALIZE
  src = pkgs.fetchurl {
    url = "https://software.sonicwall.com/NetExtender/NetExtender-linux-amd64-${version}.tar.gz";
    sha256 = "11m37m4kxykd2gwksxy4rmp3wpla36kndhrvd23z5pdidyljyn48"; # <<< ATUALIZE
  };
in
pkgs.buildFHSEnv {
  name = "netextender-${version}";

  targetPkgs =
    pkgs: with pkgs; [
      pkgs.ppp
      pkgs.zlib
      pkgs.openjdk
      pkgs.stdenv.cc.cc.lib
    ];

  runScript = pkgs.writeShellScript "netextender-install" ''
    set -e
    echo "Extraindo NetExtender ${version}..."
    tar xzf ${src} -C /tmp
    cd /tmp/NetExtender

    echo "Executando o instalador..."
    echo "y" | sudo ./install

    echo "Instalação concluída! O executável está em /usr/share/NetExtender."
    echo "Você pode executá-lo agora com: /usr/share/NetExtender/netExtender"
  '';
}
