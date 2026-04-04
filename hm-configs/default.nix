{ config, isNixOS, ... }:

let
  dotDir = "${config.home.homeDirectory}/dotfiles";
  repoDir = "${config.home.homeDirectory}/work/repositories";

in
{
  _module.args = {
    inherit dotDir;
    inherit repoDir;
    inherit isNixOS;
  };

  # dotfiles リポジトリを ghq のディレクトリ構造上に symlink する。
  # ghq get ではなく手動 clone で ~/dotfiles に置いているが、
  # fzf-cd / fzf-open 関数が ghq list を前提としているため
  # ghq のパスからも参照できるようにしておく。
  home.file."work/repositories/github.com/yukotayuki/nix-dotfiles".source =
    config.lib.file.mkOutOfStoreSymlink dotDir;

  imports = [
    ./ghostty
    ./karabiner
    ./files
    ./fonts
    ./git
    ./terminal
    ./tmux
    ./utils
    ./vim
    ./zsh
  ];
}
