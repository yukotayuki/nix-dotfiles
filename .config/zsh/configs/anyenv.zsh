# asdf
if [[ $DISTRI != 'nixos' ]]; then
    source $HOME/.asdf/asdf.sh
    # append completions to fpath
    fpath=(${ASDF_DIR}/completions $fpath)
fi
