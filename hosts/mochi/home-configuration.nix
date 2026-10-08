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
    herdr # tmux からの乗り換え検討中のターミナルマルチプレクサ（試験導入）
    k6 # 負荷テストツール
    lima # Linux VM（macOS 用）
    python312
    qemu
    redis
    sshuttle # SSH 経由 VPN
    tree
    wabt # WebAssembly Binary Toolkit
    wasmer # WebAssembly ランタイム
    watch
  ];

  # 試験導入中で頻繁に設定を調整するため、dotfiles へ直接リンクして rebuild なしで反映できるようにする。
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotDir}/.config/herdr/config.toml";
}
