local M = {
  "rcarriga/nvim-dap-ui",
  lazy = true,
}

function M.config()
  local conf = require "user.dap-core".ui.config
  require "dapui".setup(conf)
end

return M
