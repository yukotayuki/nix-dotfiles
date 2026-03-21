export LANG=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"
export HISTFILE=~/.histfile
export HISTSIZE=100000
export SAVEHIST=100000
export DIRSTACK_SIZE=100

# Homebrew (Apple Silicon)
if [ "$(uname -m)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Linux distro detection
if [ "$(uname)" = "Linux" ]; then
    export DISTRI=$(. /etc/lsb-release 2>/dev/null && echo $DISTRIB_ID)
    # ARM detection for Homebrew on Linux
    if [ "$(uname -m)" = "aarch64" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# fzf
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --info=inline'
export FZF_COMPLETION_TRIGGER=","
export FZF_COMPLETION_OPTS="
  --height 40% --reverse --border --info=inline
  --preview 'bat -n --color=always {}'
"
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
