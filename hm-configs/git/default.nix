{ config, pkgs, lib, repoDir, ... }:

{
  home.packages = with pkgs; [
    ghq
  ];
  programs.git = {
    enable = true;
    userName = "joo";
    userEmail = "yukota.yuki@hotmail.com";
    ignores = [ ".envrc" ".DS_Store" ];
    extraConfig = {
      ghq = {
        root = "${repoDir}";
      };
    };
  };

}
