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

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.graphics.enable = true;
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
  services.flatpak.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
  users.users."parte" = {
    isNormalUser = true;
    description = "Partepar";
    extraGroups = [ "networkmanager" "wheel" "libvirtd " "kvm"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim
  wget
  git
  curl
  flatpak
  fastfetch
  cava
  cmatrix
  pavucontrol
  mpv
  starship
  matugen
  lavat
  foot
  waybar
  fuzzel
  gnome-tweaks
  autotiling-rs
  nwg-look
  mako
  awww
  libnotify
  xdg-desktop-portal-gtk
  lxqt.lxqt-policykit
  xdg-desktop-portal-gtk
  vesktop
  satty  
  libsForQt5.qt5ct
  libsForQt5.qtstyleplugin-kvantum
  grim
  slurp
  wl-clipboard
  xdg-desktop-portal-wlr
  btop
  swaylock
  wleave
  wayfreeze
  wev
  vscodium
  libappindicator-gtk3
  qt6Packages.qtstyleplugin-kvantum
  (catppuccin-kvantum.override {
    variant = "mocha";
    accent = "mauve";
  })
  
  (pkgs.catppuccin-gtk.override {
  accents = [ "mauve" ];
  size = "standard";
  variant = "mocha";
  })
  ];

programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  enableCompletion = true;
};

users.defaultUserShell = pkgs.zsh;

programs.starship = {
  enable = true;
};

virtualisation.libvirtd.enable = true;
programs.virt-manager.enable = true;

security.polkit.enable = true;

hardware.steam-hardware.enable = true;

environment.gnome.excludePackages = with pkgs; [
  gnome-tour
  gnome-music
  epiphany       
  geary         
  totem         
  yelp          
  gnome-contacts
  gnome-maps
  gnome-weather
  gnome-console
  snapshot
  cheese
];

services.xserver.excludePackages = with pkgs; [
  xterm
];

documentation.nixos.enable = false;

programs.sway = {
  enable = true;
  package = pkgs.swayfx;       
  wrapperFeatures.gtk = true;   
  extraOptions = [ "--unsupported-gpu" ];  
};

environment.sessionVariables = {
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  WLR_NO_HARDWARE_CURSORS = "1"; 
  QT_STYLE_OVERRIDE = "kvantum";
};

programs.dconf.enable = true;

fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
];

xdg.portal = {
  enable = true;
  wlr.enable = true;
  extraPortals = [ 
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gtk 
  ];
};

environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
};

xdg.mime.defaultApplications = {
  "text/plain" = "codium.desktop";
  "text/x-shellscript" = "codium.desktop";
  "application/json" = "codium.desktop";
};

qt = {
  enable = true;
  # Заставляем Qt-приложения использовать системную тему GTK
  platformTheme = "gtk2"; 
  style = "kvantum";
};

# Принудительные переменные окружения, чтобы всё точно прочиталось в SwayFX
environment.variables = {
  QT_STYLE_OVERRIDE = "kvantum";
  QT_QPA_PLATFORM = "wayland";
};

environment.etc."xdg/Kvantum/kvantum.kvconfig".text = ''
  [General]
  theme=Catppuccin-Mocha-Mauve
'';

system.activationScripts.rootKvantumConfig = ''
  mkdir -p /root/.config/Kvantum
  echo -e "[General]\ntheme=Catppuccin-Mocha-Mauve" > /root/.config/Kvantum/kvantum.kvconfig
'';

# Передаем переменные в системный D-Bus и графические службы
services.dbus.packages = [ pkgs.lxqt.lxqt-policykit ];






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
