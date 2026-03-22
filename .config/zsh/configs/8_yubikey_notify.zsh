# git のネットワーク操作（push/pull/fetch/clone）を実行する直前に、
# github.com の ControlMaster ソケットが存在しない場合（= 新規 SSH 接続 = YubiKey タッチが必要）
# ターミナルにメッセージを表示する。
# ssh-agent が libfido2 を直接呼ぶため ssh-sk-helper では介入できず、
# シェルレベルで通知するこのアプローチを採用している。
# `g` は git の alias のため両方にマッチさせる。
# TODO: ssh の鍵名から対象ホストを動的に特定してより汎用的にする余地がある。
_yubikey_notify_preexec() {
  local cmd="$1"
  if [[ "$cmd" =~ ^(git|g)[[:space:]]+(push|pull|fetch|clone) ]]; then
    if [[ ! -S "$HOME/.ssh/control/git@github.com:22" ]]; then
      echo "🔑 YubiKey をタッチしてください..."
    fi
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _yubikey_notify_preexec
