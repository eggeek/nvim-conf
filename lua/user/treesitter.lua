local M = {
  "nvim-treesitter/nvim-treesitter",
  event = "User FileOpened",
  build = ":TSUpdate",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "VeryLazy",
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
    },
    -- {
    --   "HiPhish/nvim-ts-rainbow2",
    --   event = "VeryLazy",
    -- },
    {
      "windwp/nvim-ts-autotag",
      event = "VeryLazy",
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
    },
  },
}

function M.config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = {
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
			"csv"
    }, -- put the language you want in this array
    ignore_install = { "" },
    sync_install = false,
    highlight = {
      enable = true,
      disable = { "latex", "tex", "csv" },
      additional_vim_regex_highlighting = { "markdown" },
    },

    indent = { enable = false },

    matchup = { -- enable this significantly slow down ui
      enable = false
      -- enable = { "astro" },
      -- disable = { "lua" },
    },

    autotag = { enable = true },
    autopairs = { enable = true },

    -- textobjects = {
    --   select = {
    --     enable = false,
    --     -- Automatically jump forward to textobj, similar to targets.vim
    --     lookahead = true,
    --     keymaps = {
    --       -- You can use the capture groups defined in textobjects.scm
    --       ["af"] = "@function.outer",
    --       ["if"] = "@function.inner",
    --       ["at"] = "@class.outer",
    --       ["it"] = "@class.inner",
    --       ["ac"] = "@call.outer",
    --       ["ic"] = "@call.inner",
    --       ["aa"] = "@parameter.outer",
    --       ["ia"] = "@parameter.inner",
    --       ["al"] = "@loop.outer",
    --       ["il"] = "@loop.inner",
    --       ["ai"] = "@conditional.outer",
    --       ["ii"] = "@conditional.inner",
    --       ["a/"] = "@comment.outer",
    --       ["i/"] = "@comment.inner",
    --       ["ab"] = "@block.outer",
    --       ["ib"] = "@block.inner",
    --       ["as"] = "@statement.outer",
    --       ["is"] = "@scopename.inner",
    --       ["aA"] = "@attribute.outer",
    --       ["iA"] = "@attribute.inner",
    --       ["aF"] = "@frame.outer",
    --       ["iF"] = "@frame.inner",
    --     },
    --   },
    -- },
  }
end

return M
