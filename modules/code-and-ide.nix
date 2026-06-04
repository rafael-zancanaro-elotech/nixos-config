{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    zed-editor
    jetbrains.idea-ultimate
    dbeaver-bin
  ];
}
