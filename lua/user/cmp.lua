local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
			"rcarriga/cmp-dap",
    },
  },
  event = "InsertEnter",
}

function M.config()
  -- require "user.cmp-core".config()
  require "user.cmp-core".setup()
  -- config LunaSnip
  -- local utils = require "user.utils"
  -- local paths = {}
  -- local datdir = vim.fn.stdpath("data")
  -- paths[#paths + 1] = utils.join_paths(datdir, "site", "pack", "lazy", "opt", "friendly-snippets")
  require("luasnip.loaders.from_lua").lazy_load()
  -- require("luasnip.loaders.from_vscode").lazy_load { }
  -- require("luasnip.loaders.from_snipmate").lazy_load()
end

return M
