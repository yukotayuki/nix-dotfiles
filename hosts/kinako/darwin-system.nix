{ pkgs, config, ... }:

{
  networking = {
    computerName = config.hostSpec.name;
    hostName = config.hostSpec.name;
    localHostName = config.hostSpec.name;
  };

  environment.shells = [ pkgs.zsh ];

  # homebrew.enable など一部のオプションはプライマリユーザーが必要。
  # nix-darwin の multi-user 対応移行に伴い明示的に指定が必要になった。
  system.primaryUser = "joo";

  system = {
    defaults = {
      NSGlobalDomain = {
        # ホールドで文字選択候補を出さず、キーリピートを有効にする
        ApplePressAndHoldEnabled = false;
      };
      dock = {
        autohide = true;
        tilesize = 43;
      };
    };
    stateVersion = 5;
  };

  # nix.settings / nix.extraOptions を使わない理由:
  #   Determinate Nix は独自のデーモンと nix.conf を管理しており、
  #   nix-darwin の nix 管理機能と競合する（有効化すると起動時に
  #   "Determinate detected, aborting" エラーになる）。
  #   nix.enable = false にすることで nix 管理を Determinate に委譲する。
  nix.enable = false;

  programs.zsh.enable = true;
}
