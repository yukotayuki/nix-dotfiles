###################################################
#
#    alias
#
###################################################

alias ls="ls -G"
#alias ls="lsd"
alias l='ls'
#alias vim='nvim'
alias ll='ls -l'
alias la='ls -a'

#alias weather='curl http://wttr.in/'
#alias search_file='find * -type f -print | xargs grep '
alias tsource="tmux source"

if [[ $GIT_EDITOR == 'nvr' ]]; then
    alias vim = 'nvr'
fi
