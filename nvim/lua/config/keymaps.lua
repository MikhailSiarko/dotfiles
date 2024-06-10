vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set("i", "<leader>c", "<Esc>")
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set('n', '<leader>|', '<C-w><C-v>')
vim.keymap.set('n', '<leader>-', '<C-w><C-s>')

vim.keymap.set('n', '<leader>n', ':bnext<CR>')
vim.keymap.set('n', '<leader>p', ':bprevious<CR>')

vim.keymap.set('n', '<leader>w', function()
    vim.lsp.buf.format()
    vim.cmd('w!')
end)
vim.keymap.set('n', '<leader>Q', ':q<CR>')
vim.keymap.set('n', '<leader>q', ':bdelete<CR>')

vim.keymap.set('n', '<C-_>', '<C-w>-')
vim.keymap.set('n', '<C-+>', '<C-w>+')
vim.keymap.set('n', '<C->>', '<C-w>>')
vim.keymap.set('n', '<C-<>', '<C-w><')
