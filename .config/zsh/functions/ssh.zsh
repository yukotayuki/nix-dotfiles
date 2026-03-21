function ssh() {
    local profile="$1"
    local escape="\033]50;"
    local bell="\007"

    # tmux passthrough
    if [[ -n "$TMUX" ]]; then
        escape="\033Ptmux;\033\033]50;"
        bell="\007\033\\"
    fi

    echo -ne "${escape}SetProfile=${profile}${bell}"
    command ssh "$@"
    echo -ne "${escape}SetProfile=Default${bell}"
}
