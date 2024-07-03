local defs = {
  {
    "TextYankPost",
    {
      group = "_general_settings",
      pattern = "*",
      desc = "Highlight text on yank",
      callback = function()
        vim.highlight.on_yank { higroup = "Search", timeout = 100 }
      end,
    },
  },
  { -- taken from AstroNvim
    { "BufRead", "BufWinEnter", "BufNewFile" },
    {
      group = "_file_opened",
      nested = true,
      callback = function(args)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
        if not (vim.fn.expand "%" == "" or buftype == "nofile") then
          vim.api.nvim_del_augroup_by_name "_file_opened"
          vim.cmd "do User FileOpened"
          -- require("lvim.lsp").setup()
        end
      end,
    },
  },
  {
    "FileType",
    {
      group = "_hide_dap_repl",
      pattern = "dap-repl",
      command = "set nobuflisted",
    },
  },
  {
    "FileType",
    {
      group = "_filetype_settings",
      pattern = { "lua" },
      desc = "fix gf functionality inside .lua files",
      callback = function()
        ---@diagnostic disable: assign-type-mismatch
        -- credit: https://github.com/sam4llis/nvim-lua-gf
        vim.opt_local.include = [[\v<((do|load)file|require|reload|spec)[^''"]*[''"]\zs[^''"]+]]
        vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
        vim.opt_local.suffixesadd:prepend ".lua"
        vim.opt_local.suffixesadd:prepend "init.lua"

        for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
          vim.opt_local.path:append(path .. "/lua")
        end
      end,
    },
  },
  {
    "FileType",
    {
      group = "_buffer_mappings",
      pattern = {
        "qf",
        "help",
        "man",
        "floaterm",
        "lspinfo",
        "lir",
        "lsp-installer",
        "null-ls-info",
        "tsplayground",
        "DressingSelect",
        "Jaq",
        "dap-float"
      },
      callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
        vim.opt_local.buflisted = false
      end,
    },
  },
  {
    {
      "BufWinEnter",
      -- "BufFilePost",
      "BufWritePost",
      -- "TabClosed",
      -- "TabEnter",
    },
    {
      group = '_refresh_winbar',
      callback = function()
        require 'lualine'.refresh({
          place = { 'winbar' }
        })
      end
    }
  },
  { -- restore the cursor location from last time
    "BufReadPost",
    {
      group = "_cursor_loc",
      pattern = "*",
      callback = function()
        vim.cmd [[
          if line("'\"") > 1 && line("'\"") <= line("$") |
          \	 exe "normal! g`\"" |
          \ endif
        ]]
      end
    }
  },
  { -- enable spell for text file
    "FileType",
    {
      pattern = "text,tex,markdown",
      callback = function()
        vim.cmd [[ setlocal spell spelllang=en ]]
      end
    }
  },

  {
    { "BufRead", "BufWinEnter", "BufNewFile", "BufWritePost" },
    {
      callback = function()
        require("lint").try_lint()
      end,
    }
  }
}

require "user.utils".define_autocmds(defs)
