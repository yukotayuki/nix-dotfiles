{ pkgs, dotDir, ... }:

{
  programs.tmux = {
    enable = true;
    # TPM ではなく home-manager で宣言管理し、prefix+I での手動インストールを不要にする。
    plugins = with pkgs.tmuxPlugins; [
      sensible
      nord
    ];
    extraConfig = ''
      source ${dotDir}/hm-configs/tmux/tmux.conf
    '';
  };
}
