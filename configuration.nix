# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."zancanaro" = {
    isNormalUser = true;
    description = "Rafael Monteiro Zancanaro";
    extraGroups = [
      "networkmanager"
      "wheel"
      "ppp"
    ];
    packages = with pkgs; [
      #  thunderbird
      nil
      nixd
    ];
  };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Bibliotecas básicas do sistema
      stdenv.cc.cc.lib
      zlib
      glib

      # Bibliotecas do NetExtender
      ppp
      openjdk

      # Bibliotecas gráficas
      gtk3
      libGL
      libx11
      libxext
      libxtst
      libxi
      libxrender
      libxcb
      libxkbcommon
      dbus
      fontconfig
      freetype

      # WebKit para GUI
      webkitgtk_4_1

      glib
      glib-networking
      gsettings-desktop-schemas
      gtk-engine-murrine
      librsvg
      libxml2
      shared-mime-info

      # Para o file chooser
      gdk-pixbuf
      pango
      cairo
      atk
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  networking.extraHosts = ''
    127.0.0.1       angulo.localnet.qa.elotech.com.br
    127.0.0.1       ibipora.localnet.qa.elotech.com.br
    127.0.0.1       angulo.localnet.dev.elotech.com.br
    127.0.0.1       unico.localnet.dev.elotech.com.br
    127.0.0.1       unico.localnet.qa.elotech.com.br
    127.0.0.1       elotech.localnet.dev.elotech.com.br
    127.0.0.1       angulo.localnet.dev.elotech.com.br
    127.0.0.1       elotech.localnet.qa.elotech.com.br
    127.0.0.1       angulo.localnet.qa.elotech.com.br
    127.0.0.1       mppr.localnet.qa.elotech.com.br
    127.0.0.1       elotech.localnet.elotech.com.br
    127.0.0.1       angulo.localnet.elotech.com.br
    127.0.0.1       anguloadm.localnet.dev.elotech.com.br
    127.0.0.1       campinagrandedosul.localnet.elotech.com.br
    127.0.0.1       campinagrandedosul.localnet.qa.elotech.com.bru
    127.0.0.1       campinagrandedosul.localnet.dev.elotech.com.br
    127.0.0.1       marialva.localnet.qa.elotech.com.br
    127.0.0.1       marialva.localnet.dev.elotech.com.br
    127.0.0.1       palmeira.localnet.eloweb.elotech.com.br
    127.0.0.1       umuarama.localnet.eloweb.elotech.com.br
    127.0.0.1       rabbit.dev.local
    127.0.0.1       paraisodonorte.localnet.qa.elotech.com.br
    127.0.0.1       paraisodonorte.localnet.oxy.elotech.com.br
    127.0.0.1       marialva.localnet.elotech.com.br
    127.0.0.1       bentogoncalves.localnet.qa.elotech.com.br
    127.0.0.1       adm.localnet.qa.elotech.com.br
    127.0.0.1       homologacaomaringa.localnet.qa.elotech.com.br
    127.0.0.1       homologacaomaringa.cloudnet.qa.elotech.com.br
    127.0.0.1       angulo.cloudnet.qa.elotech.com.br
    127.0.0.1       adm.cloudnet.qa.elotech.com.br
    127.0.0.1       mppr.localnet.qa.elotech.com.br
    127.0.0.1       mppr.cloudnet.qa.elotech.com.br
    127.0.0.1       bentogoncalves.cloudnet.qa.elotech.com.br
  '';

  services.postgresql = {
    enable = true;
    enableTCPIP = true; # <--- Esta é a linha crucial para conexões TCP/IP
    # Suas outras configurações...
  };

  # Permitir steam-run (que é unfree)
  # nixpkgs.config.allowUnfree = true;

  # Bibliotecas necessárias para steam-run
  hardware.opengl = {
    enable = true;
  };

  # Bibliotecas adicionais
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    ppp
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
