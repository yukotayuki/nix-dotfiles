{ config, pkgs, lib, dotDir, ... }:
{
  home.packages = with pkgs; [
    peco
  ];
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

  programs.direnv = {
    enable = true;
  };
}
