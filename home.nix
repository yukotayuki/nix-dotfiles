{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in
{
  home = {
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  imports = [
    ./hm-configs
  ];

  home.packages = with pkgs; [
  ] ++ lib.lists.optionals isLinux [
    yubikey-manager
    discord
  ];

  programs.home-manager = {
    enable = true;
  };
}
