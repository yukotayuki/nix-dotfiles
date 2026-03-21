local set = vim.keymap.set

vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

set('n', '<Space>w', '<Cmd>:w<CR>')
set('n', '<Space>q', '<Cmd>:q<CR>')
set('n', '<Space>d', '<Cmd>:vs<CR>')
set('n', '<Space><S-d>', '<Cmd>:sp<CR>')
set('n', '<Space>,', '<Cmd>:edit $HOME/.config/nvim/init.lua<CR>')

set('n', 'j', 'gj')
set('n', 'k', 'gk')
set('v', 'j', 'gj')
set('v', 'k', 'gk')
set('n', '<Right>', '<C-f>')
set('n', '<Left>', '<C-b>')
set('i', '<C-f>', '<Right>')
set('i', '<C-b>', '<Left>')
set('i', '<C-a>', '<Home>')
set('i', '<C-e>', '<End>')
set('i', '<C-l>', '<Esc>')

set('n', 'sj', '<C-w>j')
set('n', 'sk', '<C-w>k')
set('n', 'sl', '<C-w>l')
set('n', 'sh', '<C-w>h')
set('n', 's.', '<C-w>>')
set('n', 's,', '<C-w><')
set('n', 'sJ', '<C-w>J')
set('n', 'sK', '<C-w>K')
set('n', 'sL', '<C-w>L')
set('n', 'sH', '<C-w>H')
