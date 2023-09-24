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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZHOMEDIR/zinit_plugins.zsh
source $ZHOMEDIR/configs/aliases.zsh
source $ZHOMEDIR/configs/setopt.zsh
source $ZHOMEDIR/configs/anyenv.zsh

# autoload
autoload -Uz colors && colors
autoload -Uz compinit && compinit

source $ZHOMEDIR/configs/misc.zsh

# flatpak for nixos
if [[ $DISTRI == 'nixos' ]]; then
    source /run/current-system/sw/etc/profile.d/flatpak.sh
fi

# setopt magic_equal_subst

# エイリアスを設定
if (( $+commands[arch] )); then
  alias x64='exec arch -arch x86_64 "$SHELL"'
  alias a64='exec arch -arch arm64e "$SHELL"'
fi

# TODO: 切り替えるパスをちゃんと設定したいところ
## 上記エイリアスが実行されると環境変数を書き換えます
#if [[ $(uname -m) == "x86_64" ]]; then
#  typeset -U path PATH
#  path=(
#    /usr/local/bin(N-/)
#    /usr/local/sbin(N-/)
#    /usr/bin
#    /usr/sbin
#    /bin
#    /sbin
#    /Library/Apple/usr/bin
#  )
#else
#  typeset -U path PATH
#  path=(
#    /opt/homebrew/bin(N-/)
#    /opt/homebrew/sbin(N-/)
#    /usr/bin
#    /usr/sbin
#    /bin
#    /sbin
#    /usr/local/bin
#    /usr/local/sbin
#    /Library/Apple/usr/bin
#  )
#fi
