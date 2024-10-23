vim.g.mapleader = " "

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")

vim.api.nvim_set_keymap("t", "<Leader><ESC>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("n", "<Leader>t", ":ToggleTerm<CR>")
vim.keymap.set("n", "<A-Tab>", ":e#<CR>")
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {})
vim.api.nvim_set_option("clipboard", "unnamedplus")
