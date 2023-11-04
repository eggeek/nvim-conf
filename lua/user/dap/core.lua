local M = {}
local notify = require 'notify'
local dap = require 'dap'
local dapui = require 'dapui'
local widgets = require 'dap.ui.widgets'
local keymaps = {
  ['n'] = { -- normal mode
    ["<C-n>"]      = dap.step_over,
    ["<C-s>"]      = dap.step_into,
    ["<C-c>"]      = dap.continue,
    ["<C-g>"]      = dap.step_out,
    ["<C-r>"]      = dap.run_to_cursor,
    ["K"]          = widgets.hover,
    ["<leader>dx"] = function()
      dap.terminate({}, {}, M.RmDbgKeyMapping)
      dapui.close()
    end,
  },
  ['x'] = { -- visual block mode
    ["K"] = widgets.hover,
  }
}

local original = {
  ["n"] = {},
  ["x"] = {},
}

local function _clear()
  original = {
    ["n"] = {},
    ["x"] = {},
  }
end

local map = function(mode, lhs, rhs)
  local exists = vim.api.nvim_get_keymap(mode)
  original[mode][lhs] = vim.tbl_filter(function(v)
    return v.lhs == lhs
  end, exists)[1] or true

  vim.keymap.set(mode, lhs, rhs)
end

function M.DbgKeyMapping()
  notify("Load Debug Keymapping", "info")
  _clear()
  for mode, mappings in pairs(keymaps) do
    for lhs, rhs in pairs(mappings) do
      map(mode, lhs, rhs)
    end
  end
end

function M.RmDbgKeyMapping()
  notify("Remove Debug Keymapping", "info")
  for mode, mapping in pairs(original) do
    for lhs, v in pairs(mapping) do
      if v == true then
        vim.keymap.del(mode, lhs)
      else
        local rhs = v.rhs
        v.lhs       = nil
        v.lhsraw    = nil
        v.lhsrawalt = nil
        v.rhs       = nil
        v.mode      = nil
        v.sid       = nil
        v.lnum      = nil
        for key, val in pairs(v) do
          if val == 0 then
            v[key] = nil
          end
        end
        print('mode:', mode, 'lhs:', lhs, 'rhs:', rhs, 'v:', vim.inspect(v))
        vim.keymap.set(mode, lhs, rhs, v)
      end
    end
  end
  _clear()
end

function M.common_dap_keymap()
  dap.listeners.after.event_initialized["dapui_config"] = function()
    notify("DBG Sesstion Start", "info")
    M.DbgKeyMapping()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    notify("DBG Sesstion Terminated", "info")
  end

  vim.keymap.set('n', '<M-b>', dap.toggle_breakpoint)
  vim.keymap.set('n', '<M-B>', function() dap.set_breakpoint(vim.fn.input("Condition: "), vim.fn.input("Num: "), nil) end)
  vim.keymap.set('n', '<leader>dd', dap.continue)
end

function M.common_dap_conf()
  require 'dap.ext.vscode'.load_launchjs(vim.fn.getcwd() .. '/.launch.json', { cppdbg = { 'c', 'cpp' } })
end

M.setup = function()

  local conf = require "user.dap.config"

  vim.fn.sign_define("DapBreakpoint", conf.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", conf.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", conf.stopped)
  dap.set_log_level("info")

  M.common_dap_keymap()
  M.common_dap_conf()

  dap.adapters.python = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/bin/debugpy-adapter',
  }

  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
  }

  require 'dapui'.setup(conf.ui.config)
end

return M
