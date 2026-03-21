{ pkgs, lib, ... }:

{
  environment.shells = [ pkgs.zsh ];

  # homebrew.enable など一部のオプションはプライマリユーザーが必要。
  # nix-darwin の multi-user 対応移行に伴い明示的に指定が必要になった。
  system.primaryUser = "joo";

  homebrew = {
    enable = true;
    # cleanup = "zap" にすると宣言にない既存パッケージが全部消えるため "none" のまま。
    # 安定したら "uninstalled" か "zap" に切り替えることを検討する。
    onActivation.cleanup = "none";
    brews = [
      # telnet: nixpkgs の inetutils は Darwin 向けビルドが不安定なため homebrew で管理
      "telnet"
    ];
    casks = [
      "claude"
      "karabiner-elements"
      "obsidian"
      "tailscale-app"
    ];
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
