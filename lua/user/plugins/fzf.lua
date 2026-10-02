-- fzf.vim, plus fzf pickers for files, spelling and BibTeX citations
local layout = { width = 0.8, height = 0.6 }

-- BibTeX files in and around the current directory, listed by the bibtex-ls command
local function bibtex_source()
	local files = {}
	for _, dir in ipairs { ".", "..", "*/", "*/**" } do
		vim.list_extend(files, vim.fn.globpath(dir, "*.bib", true, true))
	end
	return "bibtex-ls " .. table.concat(files, " ")
end

-- Pick BibTeX entries; the shell command `cmd` turns the picks into text, `insert` puts it in the buffer.
-- `place` is where the picker opens: { window = ... } or { down = ... }.
local function bibtex_pick(prompt, cmd, insert, place)
	vim.fn["fzf#run"](vim.tbl_extend("force", {
		source = bibtex_source(),
		["sink*"] = function(lines) insert(vim.fn.system(cmd, lines)) end,
		options = '--ansi --layout=reverse-list --multi --prompt "' .. prompt .. '> "',
	}, place))
end

local function append(text) vim.cmd("normal! a" .. text) end

return {
	"junegunn/fzf.vim",
	dependencies = {
		"junegunn/fzf",
		build = function() vim.fn["fzf#install"]() end,
	},
	keys = {
		{ "<leader>gf", "<cmd>GFiles<cr>", desc = "Git files" },
		{
			"<leader>ff",
			function()
				vim.fn["fzf#run"] { source = "fd -I --type f .", sink = "e", window = layout, options = '--prompt "All Files> "' }
			end,
			desc = "All files (incl. ignored)",
		},
		{
			"z=",
			function()
				vim.fn["fzf#run"] {
					source = vim.fn.spellsuggest(vim.fn.expand "<cword>"),
					sink = function(word) vim.cmd('normal! "_ciw' .. word) end,
					window = { width = 0.3, height = 0.3, yoffset = 1, xoffset = 0 },
				}
			end,
			desc = "Spelling suggestions",
		},
		{
			"<leader>ct",
			function() bibtex_pick("Cite", 'bibtex-cite -prefix="\\cite{" -postfix="}" -separator=","', append, { down = "20%" }) end,
			desc = "Insert \\cite{...}",
		},
		{
			"<leader>md",
			function() bibtex_pick("Markdown", "bibtex-markdown", append, { window = layout }) end,
			desc = "Insert Markdown reference",
		},
		{
			"<Plug>(user-cite-keys)",
			function()
				bibtex_pick("Cite", 'bibtex-cite -prefix="" -separator=","', function(text)
					vim.cmd("normal! i" .. text)
					vim.api.nvim_feedkeys("a", "n", false) -- back to insert mode, after the keys
				end, { window = layout })
			end,
		},
	},
	init = function()
		vim.g.fzf_layout = { window = layout }
		-- In TeX insert mode, @@ picks citations and inserts their keys
		-- (<C-o> runs the picker from normal mode; <C-g>u makes the insert its own undo step)
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("UserFzf", {}),
			pattern = "tex",
			callback = function(args)
				vim.keymap.set("i", "@@", "<C-g>u<C-o><Plug>(user-cite-keys)", { buffer = args.buf, remap = true })
			end,
		})
	end,
}
