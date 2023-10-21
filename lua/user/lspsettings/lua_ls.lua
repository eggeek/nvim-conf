return {
  settings = {
    Lua = {
      -- format = { enable = false, },
      diagnostics = {
        globals = { "vim", "spec" },
      },
      runtime = {
        version = "LuaJIT",
        special = {
          spec = "require",
        },
      },
      workspace = {
        checkThirdParty = false,
        maxPreload = 5000,
        preloadFileSize = 10000,
        library = {
          vim.fn.stdpath "config" .. "/lua",
          vim.fn.expand "$VIMRUNTIME",
          require("neodev.config").types(),
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
          "${3rd}/luv/library",
        },
      },
      telemetry = { enable = false, },
    },
  },
}
