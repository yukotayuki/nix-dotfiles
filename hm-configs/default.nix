{ config, pkgs, lib, isNixOS, ... }:

let
  dotDir = "${config.home.homeDirectory}/dotfiles";
  repoDir = "${config.home.homeDirectory}/work/repositories";

in
{
  _module.args.dotDir = dotDir;
  _module.args.repoDir = repoDir;
  _module.args.isNixOS = isNixOS;

  # dotfiles リポジトリを ghq のディレクトリ構造上に symlink する。
  # ghq get ではなく手動 clone で ~/dotfiles に置いているが、
  # fzf-cd / fzf-open 関数が ghq list を前提としているため
  # ghq のパスからも参照できるようにしておく。
  home.activation.dotfilesGhqSymlink = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${repoDir}/github.com/yukotayuki
    if [ ! -e ${repoDir}/github.com/yukotayuki/nix-dotfiles ]; then
      ln -s ${dotDir} ${repoDir}/github.com/yukotayuki/nix-dotfiles
    fi
  '';

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
