vim.g.completeopt = { "menuone", "noinsert", "noselect" }
vim.o.foldenable = true
vim.opt.textwidth = 120
vim.opt.swapfile = false -- creates a swapfile
-- vim.o.cursorline = true
vim.o.bdir = vim.fn.stdpath('state') .. '/backup'
vim.o.backup = true
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.showcmd = false
vim.o.ts = 2
vim.opt.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.pumblend = 0

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
