{
  pkgs,
  ...
}:

let
  codingTools = with pkgs; [
    codex
    devenv
  ];
  codexStuff = with pkgs; [
    python3
  ];
in
{

  home.packages =
    with pkgs;
    codingTools
    ++ codexStuff
    ++ [
      zed-editor
      jetbrains.idea
      dbeaver-bin
    ];
}
