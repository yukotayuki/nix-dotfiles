# fzf key bindings and completion
if [ -f /run/current-system/sw/share/fzf/key-bindings.zsh ]; then
    # NixOS
    source /run/current-system/sw/share/fzf/key-bindings.zsh
    source /run/current-system/sw/share/fzf/completion.zsh
elif type fzf &>/dev/null; then
    source <(fzf --zsh)
fi
