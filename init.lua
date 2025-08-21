LAZY_PLUGIN_SPEC = {}

function Spec(item)
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
Spec 'user.onedark'
Spec 'user.devicons'
Spec "user.treesitter"
Spec "user.lualine"
Spec "user.gitsigns"
Spec "user.indentline"

-- lsp
Spec "user.mason"
Spec "user.lspconfig"
-- spec "user.linter"
-- spec "user.schemastore"
Spec "user.navic"
Spec "user.illuminate"
Spec "user.debugger"

-- search
Spec "user.telescope"
Spec "user.project"
Spec "user.bqf"
Spec "user.fzf"

-- editing
Spec "user.cmp"
-- spec "user.autopairs"
Spec "user.comment"

-- enhancement
Spec "user.nvim-tmux"
Spec "user.notify"
Spec "user.mini"
-- spec "user.surround"
-- note taking
Spec "user.notetaking"
-- misc
Spec "user.misc"

require "user.lazy"

LoadVim 'vim/tabline.vim'
LoadVim 'vim/fzf.vim'
LoadVim 'vim/emacs-move.vim'
LoadVim 'vim/vimtex.vim'
LoadVim 'vim/custom_highlight.vim'

-- after/plugin/dap.lua
-- after/plugin/autocmds.lua
