{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;

in
{
  xdg.configFile = {
    "nix/nix.conf".source = ./nix.conf;
    "nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  } // lib.attrsets.optionalAttrs isLinux {};
}
