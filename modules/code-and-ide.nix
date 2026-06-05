{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    zed-editor
    jetbrains.idea
    dbeaver-bin
    nodejs_22
    yarn
  ];
}
