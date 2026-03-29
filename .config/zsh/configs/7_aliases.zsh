# ls
if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -G --color'
else
    alias ls='ls --color'
fi
alias l='ls -lh'
alias ll='ls -lh'
alias la='ls -lah'

# editor
alias vim='nvim'

# git
alias g='git'

# tmux
# ~/.tmux.conf を使わない理由:
#   home-manager の programs.tmux は ~/.config/tmux/tmux.conf に設定を生成する。
alias tsource='tmux source-file ~/.config/tmux/tmux.conf'

# docker compose
dc() {
    docker compose "$@"
}

# nix-darwin
# alias ではなく関数にする理由:
#   alias のシングルクォート内では $DOTDIR が展開されないため、
#   どのディレクトリから実行しても動くように関数で展開時に評価させる。
darwin-switch() {
    sudo darwin-rebuild switch --flake "${DOTDIR:-$HOME/dotfiles}#darwin@arm"
}
