{ config, pkgs, lib, ... }:

{
  xdg.configFile = {
    "nix/nix.conf".source = ./nix.conf;
    "nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  };
}
