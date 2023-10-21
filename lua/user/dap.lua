local M = {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
}

function M.config()
  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    return
  end

  local conf = require "user.dap-core"
  vim.fn.sign_define("DapBreakpoint", conf.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", conf.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", conf.stopped)

  dap.set_log_level("info")
end

return M
