{ config, pkgs, lib, ... }:

let
  repoDir = "${config.home.homeDirectory}/work/repositories";
  dotDir = "${repoDir}/github.com/yukotayuki/nix-dotfiles";

in
{
  _module.args.repoDir = repoDir;
  _module.args.dotDir = dotDir;
  imports = [
    ./asdf
    ./bat
    ./zsh
    ./vim
    ./git
    ./terminal
    ./tmux
    ./autokey
    ./files
    ./fonts
    ./utils
  ];
}
