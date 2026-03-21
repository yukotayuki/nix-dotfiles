{ config, pkgs, lib, isNixOS, ... }:

let
  dotDir = "${config.home.homeDirectory}/dotfiles";
  repoDir = "${config.home.homeDirectory}/work/repositories";

in
{
  _module.args.dotDir = dotDir;
  _module.args.repoDir = repoDir;
  _module.args.isNixOS = isNixOS;
  imports = [
    ./autokey
    ./discord
    ./files
    ./fonts
    ./git
    # ./slides
    ./terminal
    ./tmux
    ./utils
    ./vim
    ./zsh
  ];
}
