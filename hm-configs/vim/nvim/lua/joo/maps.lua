local keymap = vim.keymap

vim.g.mapleader = "\\"

keymap.set('n', '<Space>w', ':w<CR>')
keymap.set('n', '<Space>q', ':qa<CR>')
keymap.set('n', '<C-c>', ':bd<CR>')
keymap.set('n', '<Space><S-d>', ':split<Return><C-w>w', { silent = true })
keymap.set('n', '<Space>d', ':vsplit<Return><C-w>w', { silent = true })

keymap.set('', 'j', 'gj')
keymap.set('', 'k', 'gk')

keymap.set('i', '<C-f>', '<Right>')
keymap.set('i', '<C-b>', '<Left>')
keymap.set('i', '<C-e>', '<End>')
keymap.set('i', '<C-a>', '<Home>')

keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')

keymap.set('', 'rh', '<C-w><')
keymap.set('', 'rl', '<C-w>>')
keymap.set('', 'rk', '<C-w>+')
keymap.set('', 'rj', '<C-w>-')
--keymap.set('n', '<C-w><left>', '<C-w><')
--keymap.set('n', '<C-w><right>', '<C-w>>')
--keymap.set('n', '<C-w><up>', '<C-w>+')
--keymap.set('n', '<C-w><down>', '<C-w>-')

-- Do not yank with x
keymap.set('n', 'x', '"_x')
keymap.set('n', 'dw', 'vb"_d')
keymap.set('n', '<C-a>', 'gg<S-v>G')
keymap.set('n', 'tt', ':tabedit<Return>', { silent = true })
