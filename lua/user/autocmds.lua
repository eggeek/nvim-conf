local defs = {
  {
    "TextYankPost",
    {
      group = "_general_settings",
      pattern = "*",
      desc = "Highlight text on yank",
      callback = function()
        vim.hl.on_yank { higroup = "Search", timeout = 100 }
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
      pattern = { "qf", "help", "man", "dap-float" },
      callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
        vim.opt_local.buflisted = false
      end,
    },
  },
  {
    {
			"BufAdd",
			"BufNew",
			"BufDelete",
      "BufWritePost",
			"BufHidden",
      "TabClosed",
      "TabEnter",
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
      callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
          vim.api.nvim_win_set_cursor(0, mark)
        end
      end
    }
  },
  { -- enable spell for text file
    "FileType",
    {
      group = "_spell",
      pattern = "text,tex,markdown",
      callback = function()
        vim.cmd [[ setlocal spell spelllang=en ]]
      end
    }
  },

  -- {
  --   { "BufRead", "BufWinEnter", "BufNewFile", "BufWritePost" },
  --   {
  --     callback = function()
  --       require("lint").try_lint()
  --     end,
  --   }
  -- }
}

-- Each group is cleared once on creation, so re-sourcing this file doesn't duplicate autocmds
local cleared = {}
for _, def in ipairs(defs) do
  local event, opts = def[1], def[2]
  if opts.group and not cleared[opts.group] then
    vim.api.nvim_create_augroup(opts.group, { clear = true })
    cleared[opts.group] = true
  end
  vim.api.nvim_create_autocmd(event, opts)
end
