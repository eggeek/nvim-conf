local M = {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre " .. vim.fn.expand "~" .. "/Documents/obsidian/eggeek/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Documents/obsidian/eggeek/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    -- dir = "/home/eggeek/Documents/obsidian/eggeek",
    opts = {
      -- workspaces = {
      --   {
      --     name = "personal",
      --     path = "~/vaults/personal",
      --   },
      --   {
      --     name = "work",
      --     path = "~/vaults/work",
      --   },
      -- },
      completion = {
        -- If using nvim-cmp, otherwise set to false
        nvim_cmp = true,
        -- Trigger completion at 2 chars
        min_chars = 2,
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

        -- Whether to add the output of the node_id_func to new notes in autocompletion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        prepend_note_id = true
      },
      -- see below for full list of options 👇
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      },
      finder = "telescope.nvim",
    },
  },
  {
    'junegunn/vim-easy-align',
    config = function()
      vim.cmd [[
        " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)
        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)
      ]]
    end
  },
}

return M
