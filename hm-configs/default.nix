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

  # fzf-cd / fzf-open 関数が ghq list を前提としているため、手動 clone した ~/dotfiles を ghq のパスにも置く。
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
    ./yazi
    ./zsh
  ];
}
