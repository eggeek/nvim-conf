local M = {
  "mfussenegger/nvim-lint",
  lazy = true
}

function M.config()
  require('lint').linters_by_ft = {
    python = { "mypy" }
  }
end

return M
