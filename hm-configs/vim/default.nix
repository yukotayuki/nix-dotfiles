{ config, pkgs, lib, dotDir, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
  extraConfig = ''
      set rtp^=${dotDir}/.config/nvim
      set rtp+=${dotDir}/.config/nvim/after
      source ${dotDir}/.config/nvim/init.vim
    '';
in
{
  home.packages = with pkgs; [] ++ lib.lists.optionals isLinux [
    xclip
  ] ++ lib.lists.optionals isDarwin [
    reattach-to-user-namespace
  ];

  programs.vim = {
    enable = true;
    inherit extraConfig;
  };

  programs.neovim = {
    enable = true;
    inherit extraConfig;
  };
}
