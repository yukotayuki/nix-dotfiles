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
# home-manager の programs.tmux は ~/.tmux.conf ではなく ~/.config/tmux/tmux.conf に設定を生成する。
alias tsource='tmux source-file ~/.config/tmux/tmux.conf'

# docker compose
dc() {
    docker compose "$@"
}

# nix-darwin / home-manager
darwin-switch() {
    sudo darwin-rebuild switch --flake "${DOTDIR:-$HOME/dotfiles}#kinako"
}

# mochi（home-manager のみ）用
hm-switch() {
    home-manager switch --flake "${DOTDIR:-$HOME/dotfiles}#mochi"
}
