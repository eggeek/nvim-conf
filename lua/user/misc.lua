local M = {
  {
    "vale1410/vim-minizinc",
    ft = "zinc"
  },
  'lervag/vimtex',
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
  },
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchpref = { html = { nolists = 1 } }
      vim.g.matchup_matchparen_offscreen = { method = "popup", scrolloff = 1 }
    end
  },
  { -- lsp progress
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = { },
  },
  {
    'junegunn/vim-easy-align',
    config = function()
      vim.cmd [[
        " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)
        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)
      ]]
    end
  },
  -- {
  --   "ggandor/leap.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "tpope/vim-repeat"
  --   },
  --   config = function ()
  --     require('leap').create_default_mappings()
  --   end
  -- },
  { -- predefined stubs for pyright
    "microsoft/python-type-stubs",
    cond = false
  }
}
return M
