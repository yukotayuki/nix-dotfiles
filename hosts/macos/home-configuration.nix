{ pkgs, ... }:

{
  home.packages = with pkgs; [
    act          # GitHub Actions ローカル実行
    cue          # CUE 言語
    deno         # Deno ランタイム
    k6           # 負荷テストツール
    kubectl      # Kubernetes CLI
    lima         # Linux VM（macOS 用）
    nim          # Nim 言語
    python312
    qemu
    redis
    shellcheck   # シェルスクリプト linter
    sshuttle     # SSH 経由 VPN
    tree
    wabt         # WebAssembly Binary Toolkit
    wasmer       # WebAssembly ランタイム
    watch
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
