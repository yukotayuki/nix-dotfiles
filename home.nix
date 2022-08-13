{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
  repoDir = "~/work/repositories";
  dotDir = "${repoDir}/github.com/yukotayuki/nix-dotfiles";

in
{
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    jq
    htop
  ] ++ lib.lists.optionals isLinux [
  ] ++ lib.lists.optionals isDarwin [
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

  programs.git = {
    enable = true;
    userName = "joo";
    userEmail = "yukota.yuki@hotmail.com";
    ignores = [ ".envrc" ".DS_Store" ];
    extraConfig = {
      ghq = {
        root = "${repoDir}";
      };
    };
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

  programs.tmux = {
    enable = true;
    extraConfig = ''
      source ${dotDir}/tmux_custom.conf
    '';
  };
}
