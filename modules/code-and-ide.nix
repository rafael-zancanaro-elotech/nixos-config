{
  pkgs,
  ...
}:

let
  codingTools = with pkgs; [
    codex
    devenv
  ];
in
{

  home.packages =
    with pkgs;
    codingTools
    ++ [
      zed-editor
      jetbrains.idea
      dbeaver-bin
    ];
}
