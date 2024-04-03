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
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  { -- predefined stubs for pyright
    "microsoft/python-type-stubs",
    cond = false
  }
}
return M
