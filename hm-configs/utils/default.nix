{ config, pkgs, lib, isNixOS, ... }:

let
  inherit (pkgs.stdenv) isLinux;

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
    hyperfine
    fzf
    gh
    rsync
    minicom
    smartmontools
  ] ++ lib.lists.optionals isLinux [
    binutils
  ] ++ lib.lists.optionals isNixOS [
    gcc
    gnumake
  ];
}
