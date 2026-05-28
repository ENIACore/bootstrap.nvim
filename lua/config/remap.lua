vim.g.mapleader = " "

-- Go to directory
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Split screen
vim.keymap.set("n", "<leader>s", vim.cmd.vsp)

-- Switch screens
vim.keymap.set("n", "<leader>w", function() vim.cmd('wincmd w') end)

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Yank to clipboard
vim.keymap.set("v", "<leader>y", "\"+y")

-- Open undo tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Open fugitive (Git wrapper)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- Tabs at 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Line and absolute line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Give undo tree long access logs
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Only show search on single line
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- Keeps top/bottom of term 8 characters away
vim.opt.scrolloff = 8

-- Faster updates (aka error messages etc..)
vim.opt.updatetime = 50

-- Opens messages (error/info/warn) in scrollable copyable buffer
vim.keymap.set('n', '<leader>m', function()
    vim.cmd('redir @a | messages | redir END | new | put a')
end, { desc = 'Open :messages in scratch buffer' })
