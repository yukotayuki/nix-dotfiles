{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
  repoDir = "~/work/repositories";
  dotDir = "${repoDir}/github.com/yukotayuki/nix-dotfiles";

in
{
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    ghq
    ripgrep
    asdf-vm
    peco
  ] ++ lib.lists.optionals isLinux [
    gnumake
    autokey
    lshw
    pciutils
  ] ++ lib.lists.optionals isDarwin [
  ];

  nix = {
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

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
    enableCompletion = false;
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      source ${dotDir}/tmux_custom.conf
    '';
  };
}
