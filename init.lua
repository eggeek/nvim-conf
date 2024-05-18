LAZY_PLUGIN_SPEC = {}

function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = item })
end

function LoadVim(fname)
  local cmd = 'source' .. vim.fn.stdpath('config') .. '/' .. fname
  vim.cmd(cmd)
end

if vim.g.neovide then
  require 'user.neovide-opt'
end

require 'user.options'
require 'user.keymaps'.load_defaults()
-- ui
spec 'user.onedark'
spec 'user.devicons'
spec "user.treesitter"
spec "user.lualine"
spec "user.gitsigns"
spec "user.indentline"

-- lsp
spec "user.mason"
spec "user.lspconfig"
-- spec "user.schemastore"
spec "user.navic"
spec "user.illuminate"
spec "user.debugger"

-- search
spec "user.telescope"
spec "user.project"
spec "user.bqf"
spec "user.fzf"

-- editing
spec "user.cmp"
spec "user.autopairs"
spec "user.comment"

-- enhancement
spec "user.nvim-tmux"
spec "user.notify"
spec "user.term"
-- note taking
spec "user.notetaking"
-- misc
spec "user.misc"

require "user.lazy"

LoadVim 'vim/tabline.vim'
LoadVim 'vim/fzf.vim'
LoadVim 'vim/emacs-move.vim'
LoadVim 'vim/vimtex.vim'
LoadVim 'vim/custom_highlight.vim'

-- after/plugin/dap.lua
-- after/plugin/autocmds.lua
