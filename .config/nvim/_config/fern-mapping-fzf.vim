if empty(globpath(&rtp, 'autoload/fern/mapping/fzf.vim'))
  finish
endif

" fern-mapping-fzf
let s:bin_dir = expand('~/.vim/plugged/fzf.vim/bin/preview.sh')
let s:preview_command = s:bin_dir . ' {}'
let g:fern#mapping#fzf#fzf_options = {'options': ['--layout=reverse', '--info=inline', '--preview', s:preview_command ]}


