# fzf key bindings and completion
if [ -f /run/current-system/sw/share/fzf/key-bindings.zsh ]; then
    # NixOS
    source /run/current-system/sw/share/fzf/key-bindings.zsh
    source /run/current-system/sw/share/fzf/completion.zsh
elif type fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# ghq + fzf: リポジトリへ移動 (^Y)
# fzf の表示は ghq list（相対パス）にして視認性を保ちつつ、
# cd 先は $(ghq root)/$selected で絶対パスに変換する。
# ghq list -p を表示に使わない理由: 絶対パスは長くて fzf で見づらい。
function fzf-cd-git-repository() {
    local selected=$(ghq list | fzf)
    if [[ -n $selected ]]; then
        cd "$(ghq root)/$selected"
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
