local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    {
      "williamboman/mason.nvim",
      event = "User FileOpened",
      lazy = true,
    },
    "nvim-lua/plenary.nvim",
  },
  lazy = true,
  event = "User FileOpened",
}

M.servers = {
  "lua_ls",
  -- "cssls",
  -- "html",
  -- "tsserver",
  -- "astro",
  "pyright",
  -- "pylyzer",
  "bashls",
  -- "jsonls",
  -- "yamlls",
  "texlab",
  "clangd",
  -- "jdtls",
  "rust_analyzer",
  -- "marksman",
  -- "tailwindcss",
  "cmake",
  "julials"
}

M.linters = {
  "ruff",
  -- "mypy",
}

M.installed_list = require "user.utils".merge_tbls(
  M.servers, M.linters)

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }
  require("mason-lspconfig").setup {
    ensure_installed = M.installed_list
  }
end

return M
