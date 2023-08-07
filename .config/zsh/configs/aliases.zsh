###################################################
#
#    alias
#
###################################################

if [[ $(uname) == 'Darwin' ]]; then
    alias ls="ls -G"
else
    alias ls="ls --color"
    # alias ls="lsd"
fi
alias l='ls'
if [[ $(uname) == 'Darwin' ]]; then
    alias vim='nvim'
fi
alias ll='ls -l'
alias la='ls -a'

#alias weather='curl http://wttr.in/'
#alias search_file='find * -type f -print | xargs grep '
alias tsource="tmux source"

if [[ $GIT_EDITOR == 'nvr' ]]; then
    alias vim = 'nvr'
fi
