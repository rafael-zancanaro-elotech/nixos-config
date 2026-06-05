{ stdenv, writeShellScriptBin }:

writeShellScriptBin "jaspersoft-studio" ''
  exec "$HOME/.local/opt/js-studiocomm_6.21.5/Jaspersoft Studio" "$@"
''
