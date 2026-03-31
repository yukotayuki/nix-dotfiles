{ pkgs, lib, useNixOpenssh ? true, ... }:

{
  home.packages = with pkgs; [
    wget
    curl
    nmap
    # telnet: nixpkgs の inetutils は Darwin 向けビルドが不安定なため homebrew で管理
  ] ++ lib.optionals useNixOpenssh [
    # macOS 標準の OpenSSH は FIDO2（ed25519-sk）非対応のため nixpkgs 版を使用。
    # nixpkgs の openssh は libfido2 付きでビルドされており YubiKey での SSH キー生成が可能。
    # /etc/profiles/per-user が /usr/bin より PATH で優先されるため自動的に切り替わる。
    # FIDO2 不要なホストでは useNixOpenssh = false を設定して macOS 標準 SSH を使用。
    openssh
  ];
}

