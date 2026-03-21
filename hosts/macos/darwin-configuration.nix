{ pkgs, lib, ... }:

{
  environment.shells = [ pkgs.zsh ];

  # homebrew = {
  #   enable = true;
  #   brews = [ "mas" ];
  # };

  # nix.settings / nix.extraOptions を使わない理由:
  #   Determinate Nix は独自のデーモンと nix.conf を管理しており、
  #   nix-darwin の nix 管理機能と競合する（有効化すると起動時に
  #   "Determinate detected, aborting" エラーになる）。
  #   nix.enable = false にすることで nix 管理を Determinate に委譲する。
  nix.enable = false;

  programs.zsh.enable = true;

  system.stateVersion = 5;
}
