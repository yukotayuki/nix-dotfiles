_:

{
  homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall" / "zap" を使わない理由:
    #   nix-darwin の homebrew モジュールがドキュメントに反して --force-cleanup を生成するバグがある。
    #   Homebrew が --force-cleanup を廃止（2026-06 時点）したため darwin-switch が失敗する。
    #   回避策として cleanup = "none" + extraFlags で --cleanup --zap を直接渡す。
    #   nix-darwin 修正後は cleanup = "zap" に戻し extraFlags を削除する。
    onActivation.cleanup = "none";
    onActivation.extraFlags = [
      "--cleanup"
      "--zap"
    ];
    taps = [
      "trasta298/tap"
    ];
    brews = [
      # telnet: nixpkgs の inetutils は Darwin 向けビルドが不安定なため homebrew で管理
      "telnet"
      # keifu: nixpkgs 未収録のため tap 経由
      "trasta298/tap/keifu"
    ];
    casks = [
      "claude"
      "font-blex-mono-nerd-font"
      "font-noto-nerd-font"
      "font-udev-gothic-nf"
      "ghostty"
      "karabiner-elements"
      "obsidian"
      "tailscale-app"
    ];
  };
}
