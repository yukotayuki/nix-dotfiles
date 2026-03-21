if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful. %f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

source $ZHOMEDIR/zinit_plugins.zsh

# fpath
if type brew &>/dev/null; then
    fpath=($(brew --prefix)/share/zsh-completions $fpath)
fi

autoload -Uz compinit && compinit -u

# completions
if type kubectl &>/dev/null; then eval "$(kubectl completion zsh)"; fi
if type direnv &>/dev/null; then eval "$(direnv hook zsh)"; fi

bindkey -e

# source numbered config files
for config in $ZHOMEDIR/configs/[0-9]*.zsh; do
    source $config
done

# source functions
for func in $ZHOMEDIR/functions/*.zsh; do
    source $func
done

# arch switch aliases
if (( $+commands[arch] )); then
    alias x64='exec arch -arch x86_64 "$SHELL"'
    alias a64='exec arch -arch arm64e "$SHELL"'
fi

# flatpak for nixos
if [[ $DISTRI == 'nixos' ]]; then
    source /run/current-system/sw/etc/profile.d/flatpak.sh
fi
