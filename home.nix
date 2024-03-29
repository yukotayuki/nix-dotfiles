{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in
{
  home = {
    stateVersion = "22.11";
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
  ];

  programs.home-manager = {
    enable = true;
  };
}
