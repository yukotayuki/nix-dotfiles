{ pkgs, config, ... }:

{
  networking = {
    computerName = config.hostSpec.name;
    hostName = config.hostSpec.name;
    localHostName = config.hostSpec.name;
  };

  environment.shells = [ pkgs.zsh ];

  # homebrew.enable など一部のオプションはプライマリユーザーが必要。
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

  # Determinate Nix が独自のデーモンと nix.conf を管理しており、nix-darwin の nix 管理と競合するため無効にする
  # （有効化すると "Determinate detected, aborting" エラーになる）。nix.settings / nix.extraOptions も使わない。
  nix.enable = false;

  # Determinate Nix の nix.conf は nix.conf.d/ を読まず、`!include nix.custom.conf` がユーザー設定の差し込み口になっている。
  environment.etc."nix/nix.custom.conf".text = ''
    extra-trusted-users = joo
  '';

  programs.zsh.enable = true;
}
