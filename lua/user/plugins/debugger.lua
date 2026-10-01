-- Debugger loads on first use of these keys; session-only keys live in user.dap.core
local function dap(fn)
  return function() require("dap")[fn]() end
end

return {
  "mfussenegger/nvim-dap",
  dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
  keys = {
    { "<M-b>", dap "toggle_breakpoint", desc = "Toggle breakpoint" },
    {
      "<M-B>",
      function() require("dap").set_breakpoint(vim.fn.input "Condition: ", vim.fn.input "Num: ") end,
      desc = "Conditional breakpoint",
    },
    { "<leader>dd", dap "continue", desc = "Debug: start / continue" },
    {
      "<leader>dx",
      function()
        require("dap").terminate()
        require("dapui").close()
      end,
      desc = "Debug: stop and close UI",
    },
  },
  config = function()
    require("user.dap.core").setup()
  end,
}
