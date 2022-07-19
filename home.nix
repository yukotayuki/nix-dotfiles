{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;

in
{
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    jq
  ] ++ lib.lists.optionals isLinux [
    htop
  ];

  nix = {
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };
  programs.vim = {
    enable = true;
  };
  programs.direnv = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
  };
}
