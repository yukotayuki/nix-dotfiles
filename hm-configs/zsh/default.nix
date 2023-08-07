{ config, pkgs, lib, dotDir, ... }:
{
  # home.packages = with pkgs; [];

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

    zoxide = {
      enable = true;
    };
  };
}
