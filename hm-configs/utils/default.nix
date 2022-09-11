{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;

in
{
  imports = [
    ./cheetsheet.nix
    ./display_filter.nix
    ./network.nix
    ./search.nix
    ./visualization.nix
  ];
  home.packages = with pkgs; [
    unzip
  ] ++ lib.lists.optionals isLinux [
    gcc
    gnumake
    binutils
  ] ++ lib.lists.optionals isDarwin [
  ];

  programs.htop = {
    enable = true;
  };
}
