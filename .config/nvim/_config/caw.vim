scriptencoding utf-8

if empty(globpath(&rtp, 'autoload/caw.vim'))
  finish
endif

" caw toggle
nmap <Space>c <Plug>(caw:hatpos:toggle)
vmap <Space>c <Plug>(caw:hatpos:toggle)
