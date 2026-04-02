{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wget
    curl
    nmap
    # telnet: nixpkgs の inetutils は Darwin 向けビルドが不安定なため homebrew で管理
  ];
}
