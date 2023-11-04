local icons = require "user.icons"
local M = {
  breakpoint = {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  },
  breakpoint_rejected = {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = icons.ui.BoldArrowRight,
    texthl = "DiagnosticSignWarn",
    linehl = "Visual",
    numhl = "DiagnosticSignWarn",
  },
  log = {
    level = "info",
  },
  ui = {
    config = {
      icons = { expanded = "", collapsed = "", circular = "" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- Use this to override mappings for specific elements
      element_mappings = {},
      expand_lines = true,
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size = 0.33,
          position = "right",
        },
        {
          elements = {
            { id = "repl",    size = 0.65 },
            { id = "console", size = 0.35 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      controls = {
        enabled = true,
        -- Display controls in this element
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5,   -- Floats will be treated as percentage of your screen.
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,   -- Can be integer or nil.
        max_value_lines = 100,   -- Can be integer or nil.
      },
    },
  },
}

function M.common_dap_keymap()
  local dap, widgets, dapui = require("dap"), require("dap.ui.widgets"), require("dapui")
  local notify = require 'notify'

  function DbgKeyMapping()
    notify("Load Debug Keymapping", "info")
    vim.keymap.set('n', '<C-n>', dap.step_over)
    vim.keymap.set('n', '<C-s>', dap.step_into)
    vim.keymap.set('n', '<C-c>', dap.continue)
    vim.keymap.set('n', '<C-g>', dap.step_out)
    vim.keymap.set('n', '<C-r>', dap.run_to_cursor)
    vim.keymap.set('n', 'K', widgets.hover)
    vim.keymap.set('x', 'K', widgets.hover)

    vim.keymap.set('n', '<leader>dx', function()
      dap.terminate({}, {}, function()
        RmDbgKeyMapping()
        dapui.close()
      end)
    end)
  end

  function RmDbgKeyMapping()
    notify("Remove Debug Keymapping", "info")
    vim.keymap.del('n', '<C-n>')
    vim.keymap.del('n', '<C-s>')
    vim.keymap.del('n', '<C-c>')
    vim.keymap.del('n', '<C-g>')
    vim.keymap.del('n', '<C-r>')
    vim.keymap.del('n', 'K')
    vim.keymap.del('x', 'K')
    vim.keymap.del('n', '<leader>dx')
  end

  dap.listeners.after.event_initialized["dapui_config"] = function()
    notify("DBG Sesstion Start", "info")
    DbgKeyMapping()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    notify("DBG Sesstion Terminated", "info")
    -- dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    notify("DBG Sesstion Exited", "info")
    -- dapui.close()
  end

  vim.keymap.set('n', '<M-b>', dap.toggle_breakpoint)
  vim.keymap.set('n', '<M-B>', function() dap.set_breakpoint(vim.fn.input("Condition: "), vim.fn.input("Num: "), nil) end)
  vim.keymap.set('n', '<leader>dd', dap.continue)
end

function M.common_dap_conf()
  require 'dap.ext.vscode'.load_launchjs(vim.fn.getcwd() .. '/.launch.json', { cppdbg = { 'c', 'cpp' } })
end

return M
