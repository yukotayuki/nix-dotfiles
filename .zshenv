###################################################
#
#    export
#
###################################################

export ZDOTDIR=$HOME
export REPODIR=$HOME/work/repositories
export DOTDIR=$REPODIR/github.com/yukotayuki/nix-dotfiles
export ZHOMEDIR=$DOTDIR/.config/zsh

export HISTFILE=~/.histfile
export HISTSIZE=100000
export SAVEHIST=100000
export LANG=en_US.UTF-8

if [ $(uname) = "Linux" ]; then
    export DISTRI=$(. /etc/lsb-release; echo $DISTRIB_ID)
fi

if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/bin:$PATH"
fi

# vim settings
export VIMLSP="vim-lsp"
# export VIMLSP="coc"

# fzf
export FZF_DEFAULT_OPTS='--height 40%  --reverse --border --info=inline'
export FZF_COMPLETION_TRIGGER=","
export FZF_COMPLETION_OPTS="
  --height 40%  --reverse --border --info=inline 
  --preview 'bat -n --color=always {}'
"

export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
