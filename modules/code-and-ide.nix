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
    python3Full
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
