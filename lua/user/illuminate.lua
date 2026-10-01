return {
  "RRethy/vim-illuminate",
  event = "User FileOpened",
  config = function()
    require("illuminate").configure {
      providers = { "lsp", "treesitter", "regex" },
      delay = 120,
      filetypes_denylist = { "lazy", "TelescopePrompt", "csv" },
    }
  end,
}
