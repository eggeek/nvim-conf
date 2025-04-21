local M = {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    init = function ()
      vim.g.mkdp_markdown_css = '/home/eggeek/Templates/markdown/github-markdown-dark.css'
    end
  },
	{
		'chomosuke/typst-preview.nvim',
		lazy = false, -- or ft = 'typst'
		version = '1.*',
		opts = {}, -- lazy.nvim will implicitly calls `setup {}`
	}
}

return M
