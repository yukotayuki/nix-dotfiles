{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;

in
{
  imports = [
    ./cheetsheet.nix
    ./display_filter.nix
    ./search.nix
  ];
  home.packages = with pkgs; [
    ripgrep
    wget
    curl 
    unzip
  ] ++ lib.lists.optionals isLinux [
    gcc
    gnumake
    binutils
    file
    lshw
    pciutils
  ] ++ lib.lists.optionals isDarwin [
  ];

  programs.htop = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };
}
