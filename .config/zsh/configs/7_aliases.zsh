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
alias tsource='tmux source-file ~/.tmux.conf'

# docker compose
dc() {
    docker compose "$@"
}
