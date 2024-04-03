local M = {}
M.methods = {}
M.cmp = {}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end
M.methods.has_words_before = has_words_before

---@deprecated use M.methods.has_words_before instead
M.methods.check_backspace = function()
  return not has_words_before()
end

local T = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function feedkeys(key, mode)
  vim.api.nvim_feedkeys(T(key), mode, true)
end

M.methods.feedkeys = feedkeys

---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
---@param dir number 1 for forward, -1 for backward; defaults to 1
---@return boolean true if a jumpable luasnip field is found while inside a snippet
local function jumpable(dir)
  local luasnip_ok, luasnip = pcall(require, "luasnip")
  if not luasnip_ok then
    return false
  end

  if dir == -1 then
    return luasnip.in_snippet() and luasnip.jumpable(-1)
  else
    return luasnip.in_snippet() and luasnip.jumpable(1)
  end
end

M.methods.jumpable = jumpable

M.config = function()
  local status_cmp_ok, cmp_types = pcall(require, "cmp.types.cmp")
  if not status_cmp_ok then
    return
  end
  local ConfirmBehavior = cmp_types.ConfirmBehavior
  local SelectBehavior = cmp_types.SelectBehavior

  -- local cmp = require("user.utils").require_on_index "cmp"
  -- local luasnip = require("user.utils").require_on_index "luasnip"
  local cmp = require "cmp"
  local luasnip = require("luasnip")
  local cmp_window = require "cmp.config.window"
  local cmp_mapping = require "cmp.config.mapping"
  local icons = require "user.icons"

  M.cmp = {
    active = true,
    on_config_done = nil,
    enabled = function()
      local buftype = vim.api.nvim_buf_get_option(0, "buftype")
      if buftype == "prompt" then
        return false
      end
      return true
    end,
    confirm_opts = {
      behavior = ConfirmBehavior.Replace,
      select = false,
    },
    completion = {
      ---@usage The minimum length of a word to complete on.
      -- keyword_length = 2,
    },
    experimental = {
      ghost_text = { hl_group = "CmpGhostText" },
      native = false,
    },
    formatting = {
      fields = { "abbr", "kind", "menu" },
      max_width = 0,
      kind_icons = icons.kind,
      source_names = {
        nvim_lsp = "(LSP)",
        emoji = "(Emoji)",
        path = "(Path)",
        calc = "(Calc)",
        cmp_tabnine = "(Tabnine)",
        vsnip = "(Snippet)",
        luasnip = "(Snippet)",
        buffer = "(Buffer)",
        tmux = "(TMUX)",
        copilot = "(Copilot)",
        treesitter = "(TreeSitter)",
      },
      duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        luasnip = 1,
      },
      duplicates_default = 0,
      format = function(entry, vim_item)
        local max_width = 0
        if max_width ~= 0 and #vim_item.abbr > max_width then
          vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
        end
        local icon = icons.kind[vim_item.kind] or vim_item.kind
        icon = (" " .. icon .. " ") or icon
        vim_item.kind = string.format("%s %s", icon, vim_item.kind or "")
        vim_item.menu = M.cmp.formatting.source_names[entry.source.name]
        vim_item.dup = M.cmp.formatting.duplicates[entry.source.name]
            or M.cmp.formatting.duplicates_default
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp_window.bordered(),
      documentation = cmp_window.bordered(),
    },
    sources = {
      -- { name = 'nvim_lsp_signature_help' },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      -- { name = "nvim_lua" },
      { name = "path" },
      { name = "buffer",    keyword_length = 3 },
      { name = "treesitter" },
      -- { name = "crates" },
      -- { name = "tmux" },
    },
    mapping = {
      ["<C-k>"] = cmp_mapping.select_prev_item({ behavior = SelectBehavior.Select }, { "i", "c" }),
      ["<C-j>"] = cmp_mapping.select_next_item({ behavior = SelectBehavior.Select }, { "i", "c" }),
      ["<M-k>"] = cmp_mapping.scroll_docs(-4),
      ["<M-j>"] = cmp_mapping.scroll_docs(4),
      ["<C-h>"] = cmp_mapping(function(fallback)
        if jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end),
      ["<C-l>"] = cmp_mapping(function(fallback)
        if cmp.visible() then
          if cmp.get_selected_entry() then
            cmp.confirm { behavior = ConfirmBehavior.Insert, select = false }
          else
            cmp.select_next_item()
          end
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif jumpable(1) then
          luasnip.jump(1)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-e>"] = cmp_mapping.abort(),
      ["<CR>"] = cmp_mapping(function(fallback)
        if cmp.visible() then
          if cmp.get_selected_entry() then
            cmp.confirm { behavior = ConfirmBehavior.Insert, select = false }
          else
            fallback()
          end
        else
          fallback() -- if not exited early, always fallback
        end
      end),
    },
    cmdline = {
      enable = false,
      options = {
        {
          type = ":",
          sources = {
            { name = "path" },
            { name = "cmdline" },
          },
        },
        {
          type = { "/", "?" },
          sources = {
            { name = "buffer" },
          },
        },
      },
    },
  }
end

function M.setup()
  M.config()
  local cmp = require "cmp"
  cmp.setup(M.cmp)

  if M.cmp.cmdline.enable then
    for _, option in ipairs(M.cmp.cmdline.options) do
      cmp.setup.cmdline(option.type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = option.sources,
      })
    end
  end

  if M.cmp.on_config_done then
    M.cmp.on_config_done(cmp)
  end
end

return M
