local M = {
  "andymass/vim-matchup",
}

function M.config()
  -- vim.g.matchup_enabled = 0
  -- vim.g.matchup_matchparen_offscreen = { method = nil }
  vim.g.matchup_matchpref = { html = { nolists = 1 } }
  vim.g.matchup_matchparen_offscreen = { method = "popup" }

end

return M
