-- Must be set before plugins load, so their mappings use the right leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.markdown_recommended_style = 0

-- Editing
vim.o.formatoptions = "cqj"
vim.o.textwidth = 120
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.breakindent = true
vim.o.clipboard = "unnamedplus" -- share the system clipboard
vim.o.mouse = "a"

-- Search: case-insensitive unless the pattern has a capital or \C
vim.o.ignorecase = true
vim.o.smartcase = true

-- Files
vim.o.swapfile = false
vim.o.backup = true
vim.o.backupdir = vim.fn.stdpath "state" .. "/backup"
vim.o.undofile = true

-- UI
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.showcmd = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.pumblend = 0
vim.o.pumheight = 10
vim.o.winborder = "rounded"
vim.o.termguicolors = true
vim.o.completeopt = "menuone,noselect"

vim.lsp.log.set_level "off"
