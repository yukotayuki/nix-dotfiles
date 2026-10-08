# ghq + fzf: リポジトリへ移動 (^Y)
# ghq list -p の絶対パスは長くて fzf で見づらいため、相対パスを表示して cd 時に $(ghq root) を付ける。
# y は home-manager が生成する yazi のラッパーで、q で終了したら最後にいたディレクトリへ移動する。
function fzf-cd-git-repository() {
    local -a lines
    lines=("${(@f)$(ghq list | fzf --expect=ctrl-y --header='Enter: cd / Ctrl-Y: yazi')}")
    local key=$lines[1] selected=$lines[2]
    if [[ -n $selected ]]; then
        if [[ $key == ctrl-y ]]; then
            zle -I
            y "$(ghq root)/$selected" </dev/tty
        else
            cd "$(ghq root)/$selected"
        fi
    fi
    zle reset-prompt
}
zle -N fzf-cd-git-repository
bindkey '^Y' fzf-cd-git-repository

# ghq + fzf: リポジトリを open/xdg-open (^O)
function fzf-open-git-remote() {
    local selected=$(ghq list | fzf)
    if [[ -n $selected ]]; then
        if [[ -x "$(which open)" ]]; then
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

# fzf: git ブランチ切り替え (^V)
function select-git-switch() {
    local target_br=$(
        git branch -a |
            fzf --exit-0 --layout=reverse --info=hidden --no-multi \
                --preview-window="right,65%" --prompt="CHECKOUT BRANCH > " \
                --preview="echo {} | tr -d ' *' | xargs git log --oneline --color=always" |
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
bindkey "^K" select-git-switch
