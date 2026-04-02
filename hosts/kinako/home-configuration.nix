{ pkgs, ... }:

{
  home.packages = with pkgs; [
    deno
    kubectl
    nim
    shellcheck
  ];

  programs.direnv.nix-direnv.enable = true;
}
