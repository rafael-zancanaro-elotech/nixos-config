{
  stdenv,
  writeShellScriptBin,
  gsettings-desktop-schemas,
  gtk3,
  glib,
  glib-networking,
  lib,
}:

writeShellScriptBin "jaspersoft-studio" ''
  # Configurar schemas do GTK
  export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS

  # Configurar GLib e GTK
  export GSETTINGS_SCHEMAS_DIR=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}
  export GDK_BACKEND=x11

  # Suprimir warnings (opcional)
  export JAVA_TOOL_OPTIONS="-Dorg.eclipse.swt.internal.gtk.cairoGraphics=false -Declipse.e4.inject.javax.warning=false"

  # Executar o Jaspersoft Studio
  exec "$HOME/.local/opt/js-studiocomm_6.21.5/Jaspersoft Studio" "$@"
''
