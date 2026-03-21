{ config, pkgs, lib, dotDir, ... }:
{
  programs = {
    zsh = {
      enable = true;
      initContent = ''
        source ${dotDir}/.config/zsh/zshrc
      '';
      envExtra = ''
        source ${dotDir}/.config/zsh/zshenv
      '';
      enableCompletion = false;
    };

    direnv = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };

    mise = {
      enable = true;
    };
  };
}
