return {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = false,
        diagnosticMode = 'openFilesOnly',
        stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
        typeCheckingMode = 'basic'
      },
    },
  },
}
