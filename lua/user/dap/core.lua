local M = {}
local notify = require 'notify'
local dap = require 'dap'
local dapui = require 'dapui'
local widgets = require 'dap.ui.widgets'
local keymaps = {
  ['n'] = { -- normal mode
    ["<C-N>"]      = dap.step_over,
    ["<C-S>"]      = dap.step_into,
    ["<C-C>"]      = dap.continue,
    ["<C-G>"]      = dap.step_out,
    ["<C-R>"]      = dap.run_to_cursor,
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

local map = function(mode, lhs, rhs)
  -- not nil -> (mode, lhs, rhs) has been mapped before, e.g., restart
  if original[mode][lhs] ~= nil then
    return
  end
  local exists = vim.api.nvim_get_keymap(mode)
  original[mode][lhs] = vim.tbl_filter(function(v)
    return vim.api.nvim_replace_termcodes(v.lhs, true, false, true) ==
        vim.api.nvim_replace_termcodes(lhs, true, false, true)
  end, exists)[1] or true

  vim.keymap.set(mode, lhs, rhs)
  -- print("mode:", mode, "lhs:", lhs, vim.inspect(original[mode][lhs]))
end

local unmap = function(mode, lhs, item)
  -- remove from original
  original[mode][lhs] = nil

  -- no original map, directly unmap
  if item == true then
    vim.keymap.del(mode, lhs)
  else -- map to original
    -- rhs is '' if map to lua callback function
    local rhs      = item.rhs or ''
    item.lhs       = nil
    item.lhsraw    = nil
    item.lhsrawalt = nil
    item.rhs       = nil
    item.mode      = nil
    item.sid       = nil
    item.lnum      = nil
    -- remove zero value options, e.g., {expr=0}
    for key, val in pairs(item) do
      if val == 0 then
        item[key] = nil
      end
    end
    -- print("mode:", mode, "lhs:", lhs, "rhs:", rhs, "v:", vim.inspect(item))
    vim.keymap.set(mode, lhs, rhs, item)
  end
end

function M.DbgKeyMapping()
  notify("Load Debug Keymapping", "info")
  for mode, mappings in pairs(keymaps) do
    for lhs, rhs in pairs(mappings) do
      map(mode, lhs, rhs)
    end
  end
end

function M.RmDbgKeyMapping()
  notify("Remove Debug Keymapping", "info")
  for mode, mapping in pairs(original) do
    -- print("mapping:", vim.inspect(mapping))
    for lhs, v in pairs(mapping) do
      unmap(mode, lhs, v)
    end
  end
end

function M.common_dap_keymap()
  -- auto open dapui, manually close
  dap.listeners.after.event_initialized["dapui_config"] = function()
    notify("DBG Sesstion Start", "info")
    M.DbgKeyMapping()
    dapui.open()
  end

  vim.keymap.set('n', '<M-b>', dap.toggle_breakpoint)
  vim.keymap.set('n', '<M-B>', function() dap.set_breakpoint(vim.fn.input("Condition: "), vim.fn.input("Num: "), nil) end)
  vim.keymap.set('n', '<leader>dd', function()
    M.common_dap_conf()
    dap.continue()
  end)
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
