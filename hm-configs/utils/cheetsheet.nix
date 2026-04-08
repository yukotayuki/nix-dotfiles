{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cheat
    tldr
  ];
}
