{
  pkgs,
  ...
}:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    # ./virtualbox_host.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/efi";

    kernelPackages = pkgs.linuxPackages_latest;
    kernelPatches = [
      {
        name = "pinctrl_amd";
        patch = null;
        extraConfig = ''
          PINCTRL_AMD y
        '';
      }
    ];
  };

  networking = {
    hostName = "uiro";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  users.users.joo = {
    isNormalUser = true;
    shell = "/etc/profiles/per-user/joo/bin/zsh";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
    ];
    packages = with pkgs; [
      firefox
      microsoft-edge
      skypeforlinux
      nix-index
      yubioath-desktop
    ];
  };

  environment.systemPackages = with pkgs; [
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-panel-profiles
    pavucontrol
    arc-icon-theme
    gtk-engine-murrine
    gtk_engines
    sassc
    conky
    killall
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
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

    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.printing.enable = true;

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
    settings.PasswordAuthentication = true;
  };

  programs.nm-applet.enable = true;

  services.udev = {
    extraHwdb = ''
      evdev:atkbd:dmi:*
        KEYBOARD_KEY_3a=leftctrl
    '';
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.adb = {
    enable = true;
  };

  system.stateVersion = "22.05";
}
