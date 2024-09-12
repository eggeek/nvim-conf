return {
  settings = {
    pyright = {
      disableOrganizeImports = true,   -- Using Ruff
    },
    python = {
			pythonPath = vim.fn.exepath("python"),
      analysis = {
        -- ignore = { '*' }, -- Using Ruff
        -- autoSearchPaths = true,
        -- useLibraryCodeForTypes = false,
        diagnosticMode = 'openFilesOnly',
        stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
        typeCheckingMode = 'basic',
      },
    },
  },
  capabilities = {
    textDocument = {
      publishDiagnostics = {
        tagSupport = {
          valueSet = { 2 },
        },
      },
    },
  }
}
