_:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
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
