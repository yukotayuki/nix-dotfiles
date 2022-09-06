{ config, pkgs, lib, dotDir, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  home.packages = with pkgs; [] ++ lib.lists.optionals isLinux [
    xclip
  ] ++ lib.lists.optionals isDarwin [
    reattach-to-user-namespace
  ];

  programs.tmux = {
    enable = true;
    extraConfig = ''
      source ${dotDir}/hm-configs/tmux/tmux_custom.conf
    '';
  };
}
