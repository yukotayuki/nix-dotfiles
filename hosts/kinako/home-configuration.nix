{ pkgs, ... }:

{
  home.packages = with pkgs; [
    deno
    kubectl
    nim
    shellcheck
  ];
}
