{ config, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isLinux;

in
{
  home.packages = with pkgs; [
    ripgrep
    choose
  ] ++ lib.lists.optionals isLinux [
    file
    lshw
    pciutils
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };
    jq = {
      enable = true;
    };
  };
}
