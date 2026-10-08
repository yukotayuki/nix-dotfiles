{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

in
{
  home.packages =
    with pkgs;
    [
      ripgrep
      choose
    ]
    ++ lib.lists.optionals isLinux [
      file
      lshw
      pciutils
    ];

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        style = "plain";
      };
    };
    jq = {
      enable = true;
    };
  };
}
