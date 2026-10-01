-- Completion: blink.cmp, configured to behave like the previous nvim-cmp setup (user.cmp / user.cmp-core).
-- To switch back, swap `Spec "user.blink"` for `Spec "user.cmp"` in init.lua.

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

return {
  "saghen/blink.cmp",
  version = "1.*", -- release tags ship a prebuilt fuzzy matcher
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      config = function()
        require("luasnip").setup {
          region_check_events = "CursorMoved", -- exit session when cursor leaves the snippet region
          delete_check_events = "TextChanged", -- drop nodes whose text was deleted
        }
        require("luasnip.loaders.from_lua").lazy_load()
      end,
    },
    "mayromr/blink-cmp-dap", -- DAP REPL/watch completion; doesn't load nvim-dap by itself
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Defaults already turn completion off in prompt buffers; DAP buffers are allowed even when they are prompts
    enabled = function()
      local ft = vim.bo.filetype
      return (ft == "dap-repl" or vim.startswith(ft, "dapui_")) and "force" or true
    end,

    -- No preset: the presets use <C-p>/<C-n>/<C-f>/<C-b>/<C-k>, which are emacs-style insert keys here
    keymap = {
      preset = "none",
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<M-j>"] = { "scroll_documentation_down", "fallback" },
      ["<M-k>"] = { "scroll_documentation_up", "fallback" },
      ["<C-e>"] = { "cancel", "fallback" },
      ["<CR>"] = { "accept", "fallback" }, -- only when an item is selected
      ["<C-h>"] = { "snippet_backward", "fallback" },
      -- menu open: accept the selected item, or select the first one
      -- otherwise: expand/jump snippet, or open the menu after a word
      ["<C-l>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            return cmp.accept() or cmp.select_next()
          end
        end,
        function()
          local ls = require "luasnip"
          if ls.expand_or_locally_jumpable() then
            vim.schedule(ls.expand_or_jump)
            return true
          end
        end,
        function(cmp)
          if has_words_before() then
            return cmp.show()
          end
        end,
        "fallback",
      },
    },

    completion = {
      -- nothing selected or inserted until you move to an item
      list = { selection = { preselect = false, auto_insert = false } },
      -- label | icon kind | (source)
      menu = {
        draw = {
          columns = { { "label" }, { "kind_icon", "kind", gap = 1 }, { "source_name" } },
          components = {
            source_name = {
              text = function(ctx)
                return "(" .. ctx.source_name .. ")"
              end,
            },
          },
        },
      },
      documentation = { auto_show = true },
    },

    appearance = { kind_icons = require("user.icons").kind },

    snippets = { preset = "luasnip" },

    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
      per_filetype = {
        ["dap-repl"] = { "dap" },
        dapui_watches = { "dap" },
        dapui_hover = { "dap" },
      },
      providers = {
        lsp = { fallbacks = {} }, -- show buffer words alongside LSP items, not only when LSP has none
        buffer = { min_keyword_length = 3 },
        snippets = { name = "Snippet" },
        dap = { name = "DAP", module = "blink-cmp-dap" },
      },
    },

    -- command-line completion stays off; the <C-j>/<C-k> cmdline maps in keymaps.lua use the built-in menu
    cmdline = { enabled = false },
  },
  opts_extend = { "sources.default" },
}
