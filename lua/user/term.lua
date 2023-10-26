local M = {
    "akinsho/toggleterm.nvim",
    branch = "main",
    -- init = function()
    --   require("user.term-core").init()
    -- end,
    cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
    keys = require 'user.term-core'.config.open_mapping,
  }

function M.config()
  require "user.term-core".setup()
end

return M
