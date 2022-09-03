{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
  repoDir = "${config.home.homeDirectory}/work/repositories";
  dotDir = "${repoDir}/github.com/yukotayuki/nix-dotfiles";

in
{
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    ghq
    ripgrep
    peco
    wget
    curl 
    unzip
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ] ++ lib.lists.optionals isLinux [
    gcc
    gnumake
    binutils
    file
    autokey
    lshw
    pciutils
    yubikey-manager
    discord
    xclip
  ] ++ lib.lists.optionals isDarwin [
    asdf-vm
  ];

  xdg.configFile = {
    "nix/nix.conf".source = ./nix.conf;
    "nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  } // lib.attrsets.optionalAttrs isLinux {
    "autokey".source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/autokey";
    "autostart/autokey.desktop".source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/autostart/autokey.desktop";
  };

  fonts.fontconfig.enable = true;

  programs.home-manager = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.htop = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "joo";
    userEmail = "yukota.yuki@hotmail.com";
    ignores = [ ".envrc" ".DS_Store" ];
    extraConfig = {
      ghq = {
        root = "${repoDir}";
      };
    };
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      set rtp^=${dotDir}/.config/nvim
      set rtp+=${dotDir}/.config/nvim/after
      source ${dotDir}/.config/nvim/init.vim
    '';
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set rtp^=${dotDir}/.config/nvim
      set rtp+=${dotDir}/.config/nvim/after
      source ${dotDir}/.config/nvim/init.vim
    '';
  };

  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      source ${dotDir}/.zshrc
    '';
    envExtra = ''
      source ${dotDir}/.zshenv
    '';
    enableCompletion = false;
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      source ${dotDir}/tmux_custom.conf
    '';
  };
}
