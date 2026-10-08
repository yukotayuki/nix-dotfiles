export LANG=en_US.UTF-8

# Ctrl+W をパス区切り（/）で止める（既定の WORDCHARS は / を含む）。
WORDCHARS="${WORDCHARS/\//}"
export PATH="$HOME/.local/bin:$PATH"
export HISTFILE=~/.histfile
export HISTSIZE=100000
export SAVEHIST=100000

# Homebrew (Apple Silicon)
if [ "$(uname -m)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # brew shellenv は PATH の先頭に足すため、Nix で入れたコマンドが Homebrew 版に隠れないよう末尾へ回す。
    path=(${path:#/opt/homebrew/*} /opt/homebrew/bin /opt/homebrew/sbin)
fi

# Linux distro detection
if [ "$(uname)" = "Linux" ]; then
    export DISTRI=$(. /etc/lsb-release 2>/dev/null && echo $DISTRIB_ID)
    if [ "$(uname -m)" = "aarch64" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    # keychain でセッションをまたいで ssh-agent を再利用し、パスフレーズの入力を初回だけにする。
    if command -v keychain &>/dev/null; then
        eval "$(keychain --eval --quiet --confallhosts)"
    fi
fi

# fzf（FZF_DEFAULT_OPTS などは home-manager の programs.fzf で設定する。補完の 2 つは対応するオプションが無い）
export FZF_COMPLETION_TRIGGER=","
export FZF_COMPLETION_OPTS="
  --height 40% --reverse --border --info=inline
  --preview 'bat -n --color=always {}'
"
