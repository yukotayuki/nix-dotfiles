function git-prompt() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return

    local git_status
    git_status=$(git status --porcelain 2>/dev/null)

    local color
    if [[ -z "$git_status" ]]; then
        color="%F{green}"
    elif echo "$git_status" | grep -q "^[MADRCU]"; then
        color="%F{yellow}"
    else
        color="%F{red}"
    fi

    local push=""
    if git rev-parse --abbrev-ref @{u} &>/dev/null; then
        local ahead
        ahead=$(git rev-list @{u}..HEAD --count 2>/dev/null)
        [[ "$ahead" -gt 0 ]] && push=" [up]"
    fi

    echo "${color}${branch}${push}%f"
}

PROMPT='($(arch)) %2c %# '
RPROMPT='$(git-prompt)'
