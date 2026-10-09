{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
  ];
  programs = {
    broot = {
      enable = true;
    };
    eza = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--reverse"
        "--border"
        "--info=inline"
      ];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [
        "--preview 'bat -n --color=always {}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
      ];
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    };
  };
}
