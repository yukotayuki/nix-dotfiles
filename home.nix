{ pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux;

in
{
  home = {
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  imports = [
    ./hm-configs
  ];

  home.packages = lib.lists.optionals isLinux (with pkgs; [
    yubikey-manager
  ]);

  programs.home-manager = {
    enable = true;
  };
}
