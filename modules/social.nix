{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    mattermost-desktop
  ];
}
