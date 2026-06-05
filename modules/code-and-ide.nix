{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    zed-editor
    jetbrains.idea
    dbeaver-bin
    postgresql
  ];

  services.postgresql = {
    enable = true;
    enableTCPIP = true; # <--- Esta é a linha crucial para conexões TCP/IP
    # Suas outras configurações...
  };
}
