local M = {
  "numToStr/Comment.nvim",
  event = "User FileOpened",
  lazy = false,
}

function M.config()
  require("Comment").setup {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
      ---Line-comment toggle keymap
      line = "gcc",
      ---Block-comment toggle keymap
      block = "gbc",
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
      ---Line-comment keymap
      line = "gc",
      ---Block-comment keymap
      block = "gb",
    },
    ---LHS of extra mappings
    extra = {
      ---Add comment on the line above
      above = "gcO",
      ---Add comment on the line below
      below = "gco",
      ---Add comment at the end of line
      eol = "gcA",
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
      ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
      basic = false,
      ---Extra mapping; `gco`, `gcO`, `gcA`
      extra = false,
    },
    ---Function to call before (un)comment
    pre_hook = function(...)
      local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if loaded and ts_comment then
        return ts_comment.create_pre_hook()(...)
      end
    end,
    ---Function to call after (un)comment
    post_hook = nil,
  }
  local api = require('Comment.api')

  if vim.g.neovide then
    vim.keymap.set("n", "<C-/>", api.toggle.linewise.current)
  else
    vim.keymap.set('n', '<C-_>', api.toggle.linewise.current)
  end

  local esc = vim.api.nvim_replace_termcodes(
    '<ESC>', true, false, true
  )
  -- Toggle selection (linewise)
  local xToggle = function()
      vim.api.nvim_feedkeys(esc, 'nx', false)
      api.toggle.linewise(vim.fn.visualmode())
    end
  if vim.g.neovide then
    vim.keymap.set('x', '<C-/>', xToggle)
  else
    vim.keymap.set('x', '<C-_>', xToggle)
  end
end

return M
