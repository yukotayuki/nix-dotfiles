args@{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
  repoDir = "${config.home.homeDirectory}/work/repositories";
  dotDir = "${repoDir}/github.com/yukotayuki/nix-dotfiles";

in
{
  home = {
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  _module.args.repoDir = repoDir;
  _module.args.dotDir = dotDir;
  imports = [
    ./hm-configs/bat
    ./hm-configs/zsh
    ./hm-configs/vim
    ./hm-configs/git
    ./hm-configs/lazygit
    ./hm-configs/tmux
    ./hm-configs/autokey
    ./hm-configs/files
    ./hm-configs/fonts
    ./hm-configs/utils
  ];

  home.packages = with pkgs; [
  ] ++ lib.lists.optionals isLinux [
    yubikey-manager
    discord
  ] ++ lib.lists.optionals isDarwin [
    asdf-vm
  ];

  programs.home-manager = {
    enable = true;
  };
}
