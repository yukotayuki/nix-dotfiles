{ config, pkgs, lib, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        language = "ja";
        showIcons = true;
      };
      os = {
        editCommand = "vim";
      };
    };
  };
}
