{
  pkgs,
  config,
  dotDir,
  ...
}:

{
  home.packages = with pkgs; [
    act # GitHub Actions ローカル実行
    cue # CUE 言語
    deno # Deno ランタイム
    herdr # tmux からの乗り換え検討中のターミナルマルチプレクサ（試験導入）
    k6 # 負荷テストツール
    kubectl # Kubernetes CLI
    lima # Linux VM（macOS 用）
    nim # Nim 言語
    python312
    qemu
    redis
    shellcheck # シェルスクリプト linter
    sshuttle # SSH 経由 VPN
    tree
    wabt # WebAssembly Binary Toolkit
    wasmer # WebAssembly ランタイム
    watch
  ];

  # mkOutOfStoreSymlink を使う理由:
  #   試験導入中で頻繁に設定を調整するため、Nix store へのコピーではなく
  #   dotfiles への直接リンクにして rebuild なしで反映できるようにする。
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/herdr/config.toml";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
