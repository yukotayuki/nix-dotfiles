# -------------------
# zstyleのdefault設定
# -------------------
zstyle :compinstall filename "$HOME/.zshrc"

zstyle ":completion:*:commands" rehash 1
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

brew_fzf_shell="`brew --prefix`/Cellar/fzf/0.42.0/shell"
if [ -e $brew_fzf_shell ]; then
  source "$brew_fzf_shell/key-bindings.zsh"
  source "$brew_fzf_shell/completion.zsh"
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

function select-git-switch() {
  target_br=$(
    git branch -a |
      fzf --exit-0 --layout=reverse --info=hidden --no-multi --preview-window="right,65%" --prompt="CHECKOUT BRANCH > " --preview="echo {} | tr -d ' *' | xargs git lg --color=always" |
      head -n 1 |
      perl -pe "s/\s//g; s/\*//g; s/remotes\/origin\///g"
  )
  if [ -n "$target_br" ]; then
    BUFFER="git switch $target_br"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N select-git-switch
bindkey "^V" select-git-switch

# 関数
function git-prompt {
  local branchname
  branchname=`git symbolic-ref --short HEAD 2> /dev/null`
  if [ -z $branchname ]; then
    return
  fi

  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    branch="%{${fg[green]}%}($branchname)%{$reset_color%}"
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    branch="%{${fg[yellow]}%}($branchname)%{$reset_color%}"
  else
    branch="%{${fg[red]}%}($branchname)%{$reset_color%}"
  fi

  remote=`git config branch.${branchname}.remote 2> /dev/null`

  if [ -z $remote ]; then
    pushed=''
  else
    upstream="${remote}/${branchname}"
    if [[ -z `git log ${upstream}..${branchname}` ]]; then
      pushed="%{${fg[green]}%}[up]%{$reset_color%}"
    else
      pushed="%{${fg[red]}%}[up]%{$reset_color%}"
    fi
  fi

  echo "$branch$pushed"
}

# PROMPT='%n@%m`git-prompt` %# '
PROMPT='($(arch)) %2c %# '
# RPROMPT='%{$fg_bold[cyan]%}[%C]%{$reset_color%}'
RPROMPT='`git-prompt` %{$fg_bold[cyan]%}%{$reset_color%}'
