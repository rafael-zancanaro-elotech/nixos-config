{
  pkgs,
  ...
}:
{
  imports = [
    ../programs/ulauncher.nix
  ];
  home.packages = with pkgs; [
    spotify
  ];
}
