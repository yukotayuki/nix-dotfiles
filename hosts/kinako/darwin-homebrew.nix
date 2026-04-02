_:

{
  homebrew = {
    enable = true;
    # "zap" にすると宣言にない既存パッケージが全部消えるため "uninstall" にとどめる。
    # 宣言から外したパッケージは次回 darwin-switch 時にアンインストールされる。
    onActivation.cleanup = "uninstall";
    brews = [
      # telnet: nixpkgs の inetutils は Darwin 向けビルドが不安定なため homebrew で管理
      "telnet"
    ];
    casks = [
      "claude"
      "font-noto-nerd-font"
      "font-udev-gothic-nf"
      "ghostty"
      "karabiner-elements"
      "obsidian"
      "tailscale-app"
    ];
  };
}
