-- "Debug mode": keys below override normal keys only while a debug session runs.
local M = {}

local dap = require "dap"
local dapui = require "dapui"
local notify = require "notify"

local session_keys = {
  { "n", "<C-n>", dap.step_over },
  { "n", "<C-s>", dap.step_into },
  { "n", "<C-c>", dap.continue },
  { "n", "<C-g>", dap.step_out },
  { "n", "<C-r>", dap.run_to_cursor },
  { "n", "<C-w>=", function() dapui.open { reset = true } end },
  { "x", "K", function() require("dap.ui.widgets").hover() end },
}

local saved -- non-nil while in debug mode: previous global mappings (or false if none)

local function enter()
  if saved then
    return
  end
  saved = {}
  for i, k in ipairs(session_keys) do
    local prev = vim.fn.maparg(k[2], k[1], false, true)
    -- ignore buffer-local maps: they shadow ours anyway and must not be re-set globally
    saved[i] = (next(prev) and prev.buffer == 0) and prev or false
    vim.keymap.set(k[1], k[2], k[3], { desc = "Debug" })
  end
  notify("Debug mode on", "info")
end

local function leave()
  if not saved then
    return
  end
  for i, k in ipairs(session_keys) do
    if saved[i] then
      vim.fn.mapset(saved[i]) -- restores rhs or Lua callback exactly
    else
      pcall(vim.keymap.del, k[1], k[2])
    end
  end
  saved = nil
  notify("Debug mode off", "info")
end

function M.active()
  return saved ~= nil
end

function M.setup()
  local conf = require "user.dap.config"
  vim.fn.sign_define("DapBreakpoint", conf.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", conf.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", conf.stopped)
  dap.set_log_level(conf.log.level)

  dap.listeners.after.event_initialized["user_debug_mode"] = function()
    enter()
    dapui.open() -- opened automatically, closed manually (<leader>dx) so output stays readable
  end
  -- ponytail: leaves on the first session that ends; per-session tracking if child sessions matter
  for _, ev in ipairs { "event_terminated", "event_exited", "disconnect" } do
    dap.listeners.before[ev]["user_debug_mode"] = leave
  end

  dap.adapters.python = {
    type = "executable",
    command = vim.fn.stdpath "data" .. "/mason/bin/debugpy-adapter",
  }
  dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath "data" .. "/mason/bin/OpenDebugAD7",
  }
  dap.adapters.codelldb = {
    -- on MacOS, cppdbg needs lldb_mi, which is buggy
    -- https://github.com/microsoft/vscode-cpptools/issues/7240
    type = "server",
    port = "4711",
    executable = {
      command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
      args = { "--port", "4711" },
      detached = false,
    },
  }

  dapui.setup(conf.ui.config)
end

return M
