{ pkgs, ... }:

{
  home.packages = with pkgs; [
    deno
    kubectl
    nim
    shellcheck
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
