if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

export DISTRI=$(. /etc/lsb-release; echo $DISTRIB_ID)
export REPODIR="$HOME/work/repositories"
export DOTDIR="$REPODIR/github.com/yukotayuki/nix-dotfiles"
export ZHOMEDIR="$DOTDIR/.config/zsh"
source $ZHOMEDIR/zinit_plugins.zsh
source $ZHOMEDIR/configs/aliases.zsh
source $ZHOMEDIR/configs/setopt.zsh
source $ZHOMEDIR/configs/misc.zsh
source $ZHOMEDIR/configs/anyenv.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vim settings
export VIMLSP="vim-lsp"
# export VIMLSP="coc"

setopt magic_equal_subst

