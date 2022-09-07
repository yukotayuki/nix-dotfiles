{ config, pkgs, lib, dotDir, ... }:

let
  inherit (pkgs.stdenv) isDarwin;

in lib.mkIf (isDarwin) 
{
  home.packages = with pkgs; [ asdf-vm ];
}
