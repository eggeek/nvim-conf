return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  main = "project_nvim",
  keys = {
    { "<leader>pj", function() require("telescope").extensions.projects.projects() end, desc = "Projects" },
  },
  opts = {
    manual_mode = false,
    detection_methods = { "pattern" },
    patterns = { "!.gitconfig", ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
    ignore_lsp = {},
    exclude_dirs = {},
    show_hidden = false,
    silent_chdir = true,
    scope_chdir = "global",
  },
}
