{ config, pkgs, lib, dotDir, ... }:
{
  home.packages = with pkgs; [
    peco
  ];

  programs = {
    zsh = {
      enable = true;
      initExtra = ''
        source ${dotDir}/.zshrc
      '';
      envExtra = ''
        source ${dotDir}/.zshenv
      '';
      enableCompletion = false;
    };

    direnv = {
      enable = true;
    };

    mcfly = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };
  };
}
