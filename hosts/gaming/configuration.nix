{ config
, pkgs
, ...
}:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "libdwarf-20210528"
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/efi";

    # loader.grub.enable = true;
    # loader.grub.version = 2;
    # loader.grub.efiSupport = true;
    # loader.grub.efiInstallAsRemovable = true;
    # loader.grub.device = "nodev";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
  };

  users.users.joo = {
    isNormalUser = true;
    shell = "/etc/profiles/per-user/joo/bin/zsh";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [
      firefox
      microsoft-edge
      skypeforlinux
      nix-index
      yubioath-desktop
    ];
  };

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };

  environment.systemPackages = with pkgs; [
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-panel-profiles
    pavucontrol
    plata-theme
    arc-icon-theme
    gtk-engine-murrine
    gtk_engines
    sassc
    conky
    killall
  ];

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      ipafont
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ 
          "IPAPGothic"
          "Noto Sans CJK JP"
        ];
        serif = [ 
          "IPAPMincho"
          "Noto Serif JP"
        ];
      };
    };
  };

  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "joo";
    };

    desktopManager.xfce.enable = true;

    videoDrivers = [ "nvidia" ];

    layout = "us";
    xkbVariant = "";
  };

  hardware = {
    opengl.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  };


  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
  };

  programs.nm-applet.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  # for yubioath-desktop
  services.udev.packages = with pkgs; [yubikey-personalization];
  services.pcscd.enable = true;

  # flatpak
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    # gtkUsePortal = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  system.stateVersion = "22.05";
}
