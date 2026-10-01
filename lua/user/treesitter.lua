local M = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- main branch does not support lazy-loading
  build = ":TSUpdate",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
      init = function()
        vim.g.skip_ts_context_commentstring_module = true
      end,
      opts = {},
    },
    {
      "windwp/nvim-ts-autotag",
      event = "VeryLazy",
      opts = {},
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
    },
  },
}

-- filetypes left to regex/vimtex highlighting
local no_highlight = { latex = true, tex = true, csv = true }
-- filetypes that keep regex highlighting on top of treesitter
local regex_too = { markdown = true }

function M.config()
  require("nvim-treesitter").install {
    "lua",
    "markdown",
    "markdown_inline",
    "latex",
    "bash",
    "python",
    "cpp",
    "rust",
    "vimdoc",
    "query",
    "typst",
    "csv",
  }

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitter", {}),
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      if no_highlight[ft] then
        return
      end
      -- pcall: skip filetypes without a parser
      if pcall(vim.treesitter.start, args.buf) and regex_too[ft] then
        vim.bo[args.buf].syntax = "on"
      end
    end,
  })
end

return M
