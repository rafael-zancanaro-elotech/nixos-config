{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    spotify
    ulauncher
  ];
}
