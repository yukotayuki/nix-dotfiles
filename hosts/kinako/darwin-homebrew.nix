_:

{
  homebrew = {
    enable = true;
    # brew bundle dump で現状確認済み（2026-04-09）。
    # 宣言と実態が一致しているため "zap" に変更。
    # 以後、宣言にないパッケージは darwin-switch 時に自動削除される。
    onActivation.cleanup = "zap";
    brews = [
      # telnet: nixpkgs の inetutils は Darwin 向けビルドが不安定なため homebrew で管理
      "telnet"
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
