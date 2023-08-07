# -------------------
# zstyleのdefault設定
# -------------------
zstyle :compinstall filename "$HOME/.zshrc"

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:default' menu select=1


# --------------
# cdr関連の設定
# --------------

## スタックサイズ(cdの履歴)
DIRSTACKSIZE=100


# --------------
# hook関数の登録
# --------------

## cdr, add-zsh-hook の有効化
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs


# -------------
# bindkeyの設定
# -------------

## emacsモード
bindkey -e

# --------------
# fzf関連の設定
# --------------

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

function fzf-cd-git-repository() {
  local selected=`ghq list | sed 's/^[^ ][^ ]*  *//' | fzf`
  if [[ -n $selected ]]; then
    cd $REPODIR/$selected
  fi
  zle reset-prompt
}
zle -N fzf-cd-git-repository
bindkey '^Y' fzf-cd-git-repository

function fzf-open-git-remote() {
  local selected=`ghq list | sed 's/^[^ ][^ ]*  *//' | fzf`
  if [[ -n $selected ]]; then
    if [[ -x "`which open`" ]]; then
      BUFFER="open https://${selected}"
    else
      BUFFER="xdg-open https://${selected}"
    fi
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf-open-git-remote
bindkey '^O' fzf-open-git-remote
