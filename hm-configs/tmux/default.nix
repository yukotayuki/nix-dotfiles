{ config, pkgs, lib, dotDir, ... }:

{
  programs.tmux = {
    enable = true;
    # TPM を使わない理由:
    #   home-manager の plugins で宣言管理すると prefix+I での手動インストールが不要になる。
    plugins = with pkgs.tmuxPlugins; [
      sensible
      nord
    ];
    extraConfig = ''
      source ${dotDir}/hm-configs/tmux/tmux.conf
    '';
  };
}
