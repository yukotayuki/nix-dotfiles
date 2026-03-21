{ pkgs, lib, ... }:

{
  environment.shells = [ pkgs.zsh ];

  # homebrew.enable など一部のオプションはプライマリユーザーが必要。
  # nix-darwin の multi-user 対応移行に伴い明示的に指定が必要になった。
  system.primaryUser = "joo";

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
      "font-udev-gothic-nf"
      "ghostty"
      "karabiner-elements"
      "obsidian"
      "tailscale-app"
    ];
  };

  system.defaults = {
    NSGlobalDomain = {
      # ホールドで文字選択候補を出さず、キーリピートを有効にする
      ApplePressAndHoldEnabled = false;
    };
    dock = {
      autohide = true;
      tilesize = 43;
    };
  };

  # nix.settings / nix.extraOptions を使わない理由:
  #   Determinate Nix は独自のデーモンと nix.conf を管理しており、
  #   nix-darwin の nix 管理機能と競合する（有効化すると起動時に
  #   "Determinate detected, aborting" エラーになる）。
  #   nix.enable = false にすることで nix 管理を Determinate に委譲する。
  nix.enable = false;

  programs.zsh.enable = true;

  system.stateVersion = 5;
}
