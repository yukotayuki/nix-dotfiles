{ pkgs, config, ... }:

let
  inherit (import ../../vars.nix) username;
in
{
  networking = {
    computerName = config.hostSpec.name;
    hostName = config.hostSpec.name;
    localHostName = config.hostSpec.name;
  };

  environment.shells = [ pkgs.zsh ];

  # homebrew.enable など一部のオプションはプライマリユーザーが必要。
  system.primaryUser = username;

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
    extra-trusted-users = ${username}
  '';

  # Nix が生成する CA バンドル（/etc/ssl/certs/ca-certificates.crt）から除外する。macOS のキーチェーンには影響しない。
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
  ];

  programs.zsh.enable = true;
}
