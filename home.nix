{ pkgs, lib, ... }:

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

  home.packages = lib.lists.optionals isLinux (with pkgs; [
    yubikey-manager
  ]);

  programs.home-manager = {
    enable = true;
  };
}
