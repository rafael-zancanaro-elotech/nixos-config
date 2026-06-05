{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    zed-editor
    jetbrains.idea
    dbeaver-bin
  ];
}
