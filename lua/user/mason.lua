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
  "ruff_lsp",
  "texlab",
  "clangd",
  -- "jdtls",
  "rust_analyzer",
  -- "marksman",
  -- "tailwindcss",
  "cmake"
}

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }
  require("mason-lspconfig").setup {
    ensure_installed = M.servers,
  }
end

return M
