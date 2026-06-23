{
  pkgs,
  ...
}:
{
  imports = [
    ../programs/ulauncher
  ];
  home.packages = with pkgs; [
    spotify
  ];
}
