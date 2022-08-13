#zmodload zsh/datetime
#
#function preexec() {
#  __TIMER=$EPOCHREALTIME
#}
#
#function powerline_precmd() {
#  local __ERRCODE=$?
#  local __DURATION=0
#
#  if [ -n $__TIMER ]; then
#    local __ERT=$EPOCHREALTIME
#    __DURATION="$(($__ERT - ${__TIMER:-__ERT}))"
#  fi
#
#  PS1="$(powerline-go -modules duration -duration $__DURATION -error $__ERRCODE -shell zsh)"
#  unset __TIMER
#}

function powerline_precmd() {
    #PS1="$($GOPATH/bin/powerline-go -error $? -shell zsh)"
    #PS1="$($GOPATH/bin/powerline-go -error $? -shell zsh -eval -modules-right git)"
    #PS1="$($GOPATH/bin/powerline-go -colorize-hostname  -error $? -shell zsh -eval -modules-right git)"
    #eval "$($GOPATH/bin/powerline-go -error $? -shell zsh -eval -modules-right git)"
    eval "$($GOPATH/bin/powerline-go -error $? -shell zsh -eval \
            -modules user,ssh,git -modules-right perms,gitlite,cwd -cwd-mode plain \
            -max-width 30 -cwd-max-dir-size 5 -colorize-hostname -cwd-max-depth 10)"  
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi
