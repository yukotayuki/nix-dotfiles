_:

{
  # Ubuntu が Nix で入れたアプリやデスクトップエントリを見つけられるよう、XDG_DATA_DIRS などを設定する。
  targets.genericLinux.enable = true;
  # GPU ドライバーの連携は sudo でのセットアップが要るため、必要になるまで有効にしない。
  targets.genericLinux.gpu.enable = false;

  # canele 固有のパッケージ・設定をここに追加する。
  # home-manager スタンドアロンでの動作のため、
  # systemd サービスなどシステムレベルの設定は記述できない。
}
