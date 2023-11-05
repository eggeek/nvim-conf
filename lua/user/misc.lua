local M = {
  {
    "vale1410/vim-minizinc",
    ft = "zinc"
  },
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
  }
}
return M
