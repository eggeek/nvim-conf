local M = {
  "RRethy/vim-illuminate",
  event = "User FileOpened",
}

function M.config()
  require("illuminate").configure {
      -- providers: provider used to get references in the buffer, ordered by priority
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      -- delay: delay in milliseconds
      delay = 120,
      -- filetype_overrides: filetype specific overrides.
      -- the keys are strings to represent the filetype while the values are tables that
      -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
      filetype_overrides = {},
      -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "nvimtree",
        "lazy",
        "neogitstatus",
        "trouble",
        "lir",
        "outline",
        "spectre_panel",
        "toggleterm",
        "dressingselect",
        "telescopeprompt",
				"csv"
      },
      -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
      filetypes_allowlist = {},
      -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
      modes_denylist = {},
      -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
      modes_allowlist = {},
      -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
      -- only applies to the 'regex' provider
      -- use :echom synidattr(synidtrans(synid(line('.'), col('.'), 1)), 'name')
      providers_regex_syntax_denylist = {},
      -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
      -- only applies to the 'regex' provider
      -- use :echom synidattr(synidtrans(synid(line('.'), col('.'), 1)), 'name')
      providers_regex_syntax_allowlist = {},
      -- under_cursor: whether or not to illuminate under the cursor
      under_cursor = true,
  }
end

return M
