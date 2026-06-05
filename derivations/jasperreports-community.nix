{
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  lib,
}:

let
  version = "6.21.5";
  pname = "jasperreports";

  src = fetchurl {
    url = "https://github.com/Jaspersoft/jasperreports/releases/download/${version}/jasperreports-${version}-project.tar.gz";
    sha256 = "10pq3xjyr00bdyw1j81absr2wbsi5rc0b4plp04ig6nm9iypa5n9";
  };

in
stdenv.mkDerivation {
  name = "${pname}-${version}";
  inherit src;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,share}

    # Extrair o tarball
    tar xzf $src -C $out/share

    # Encontrar os JARs principais
    find $out/share -name "*.jar" -exec cp {} $out/lib/ \;

    # Criar wrapper para executar os principais JARs (ajuste conforme necessidade)
    for jar in $out/lib/jasperreports-*.jar; do
      jar_name=$(basename $jar .jar)
      makeWrapper ${jre}/bin/java $out/bin/$jar_name \
        --add-flags "-jar $jar"
    done

    # Se tiver scripts de exemplo, copiar
    if [ -d "$out/share/demo" ]; then
      cp -r $out/share/demo $out/share/demos
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "JasperReports Library - Java reporting library";
    homepage = "https://github.com/Jaspersoft/jasperreports";
    license = licenses.lgpl3Only; # Verificar licença - JasperReports é LGPL
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
