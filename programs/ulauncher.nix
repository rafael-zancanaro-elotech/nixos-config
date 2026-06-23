{
  pkgs,
  ...
}:
let
  dependencies = with pkgs; [
    wmctrl
  ];
in
{

  home.packages =
    with pkgs;
    dependencies
    ++ [
      ulauncher
    ];
}
