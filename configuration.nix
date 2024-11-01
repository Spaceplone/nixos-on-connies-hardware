# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  zramSwap.enable = true; #changed: tried to enabled zram

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

    services.avahi = {
    enable = true;
    nssmdns4 = true;  # Enable mDNS support in NSS
    publish.userServices = true;
  };


  #try to control kde log spam
  services.rsyslogd = {
  enable = true;
  extraConfig = ''
    :msg, contains, "kpipewire_logging" stop
  '';
};

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true; #changed: tried disabling this to better handle memory pressure situations
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

##try stacking low latency pulse for pW
# this didnt work btw, the real solution is $ export PULSE_LATENCY_MSEC=20

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.conneh = {
    isNormalUser = true;
    description = "conneh";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # install steam
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #enable flatpak
  services.flatpak.enable = true;

  #enable docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
};

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

    nixpkgs.overlays = [
    (self: super: {
      nomachine-client = pkgs.callPackage /home/conneh/actual/development/nix/nomachine-client/default.nix {};
      vban = pkgs.callPackage "/home/conneh/actual/development/nix/vban-git ater/default.nix" {};
      appmenu-gtk-module = pkgs.callPackage "/home/conneh/actual/development/nix/appmenu-gtk3-module/default.nix" {};
    })
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    noto-fonts-cjk
    libsForQt5.qt5.qttools
    #gtk3 ## didnt work i guess
    maliit-keyboard
    vscode
    git
    python3
    python311Packages.pip
    chromium
    hyfetch #make the ricing gayer
    discord #irc+teamspeak, but bourgeois
    brave
    teamspeak_client
    moonlight-qt
    gcc
    nix-index
    cifs-utils    
    obs-studio
    pavucontrol
    telegram-desktop
    nomachine-client #i only pretend to have migrated away from windows
    keepassxc
    htop
    pidgin
    clementine
    vlc
    skanlite
    pdfarranger
    onboard
    google-chrome
    k4dirstat
    libreoffice
    gimp
    fsearch
    libnotify
    betterbird
    gnome.gnome-software #for flatpaks
    kdePackages.partitionmanager
    efibootmgr
    revolt-desktop
    freefilesync
    lm_sensors
    btop
    pioneer
    evolution
    evolution-ews
    mission-center
    meld
    openrgb
    element-desktop
    moltengamepad #havent used this much
    xboxdrv
    speedcrunch
    vban
    unityhub
    icu  # java
    dotnet-sdk
    openjdk
    maven
    jetbrains.rider
    jetbrains.idea-community # maybe remove
    lact #radeon-profile
    linuxKernel.packages.linux_6_11.hid-tmff2
    input-utils
    android-tools  # should contain adb that one of my flatpaks needs
    dbeaver-bin
    cargo #should be in devshells
    plasma-hud
  ];

    xdg.mime.defaultApplications = {
    "text/plain" = "code.desktop";
    "text/html" = "waterfox-modern.desktop";
    "text/xml" = "waterfox-modern.desktop";
    "application/xhtml+xml" = "waterfox-modern.desktop";
    "x-scheme-handler/http" = "waterfox-modern.desktop";
    "x-scheme-handler/https" = "waterfox-modern.desktop";
  };

    xdg.portal = {

    enable = true;

    xdgOpenUsePortal = true;

  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    fuse3
    fuse
    xorg.libX11
    libGL
    libdrm
    xorg.libxcb
    libstdcxx5
    harfbuzz
    harfbuzzFull
    gcc
    libstdcxx5
    gtk3
    gtk3-x11
    alsa-lib-with-plugins
    xorg.libXtst
    dbus-glib    
    xorg.libXt
    glib
    gsettings-desktop-schemas
    libpulseaudio
    winePackages.unstableFull
    libxcrypt
    libnotify
    noto-fonts-cjk
    icu
    dotnet-sdk
  ];

  environment.sessionVariables = {
  DOTNET_ROOT = "${pkgs.dotnet-sdk}"; # this may not have worked
  HISTIGNORE="*-openjdk-*";
};



    systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  services.mysql = {
  enable = true;
  package = pkgs.mariadb;
};

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

## try enable cpufreq govnah
  boot.kernelModules = [ 
    "cpufreq_conservative"  # Conservative governor
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
