{ config, pkgs, lib, isNixOS, ... }:

let
  repoDir = "${config.home.homeDirectory}/work/repositories";
  dotDir = "${repoDir}/github.com/yukotayuki/nix-dotfiles";

in
{
  _module.args.repoDir = repoDir;
  _module.args.dotDir = dotDir;
  _module.args.isNixOS = isNixOS;
  imports = [
    # ./asdf
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
