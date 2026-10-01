-- General keymaps. Plugin keymaps live in the plugin's spec (`keys`).
local map = vim.keymap.set
local s = { silent = true }

-- Insert: save, emacs-style movement
map("i", "<C-s>", "<cmd>w<cr><esc>", s)
map("i", "<C-p>", "<Up>", s)
map("i", "<C-n>", "<Down>", s)
map("i", "<C-f>", "<Right>", s)
map("i", "<C-b>", "<Left>", s)
map("i", "<C-k>", "<cmd>normal!d$<cr><END>", s) -- normal! rather than <C-o> to avoid triggering events
map("i", "<C-a>", "<cmd>normal!^<cr>", s)
map("i", "<C-e>", "<END>", s)

-- Fzf
map("n", "z=", "<cmd>call FzfSpell()<cr>", s)
map("n", "<leader>gf", "<cmd>GFiles<cr>", s)

-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize -2<cr>", s)
map("n", "<C-Down>", "<cmd>resize +2<cr>", s)
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", s)
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", s)

-- Diagnostics
map("n", "<leader>q", vim.diagnostic.setloclist, s)
map("n", "<leader>df", vim.diagnostic.open_float, s)
map("n", "<leader>dl", function()
	vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end, s)

-- Clear search highlight
map("n", "<M-l>", "<cmd>nohlsearch<Bar>diffupdate<Bar>echo <cr>", s)

-- Horizontal scroll
map("n", "<M-e>", "zh", s)
map("n", "<M-y>", "zl", s)

-- Keep cursor centered / in place; move by screen line
map("n", "n", "nzzzv", s)
map("n", "N", "Nzzzv", s)
map("n", "j", "gj", s)
map("n", "k", "gk", s)
map("n", "J", "mzJ`z", s)

-- Save, tabs
map("n", "<C-s>", "<cmd>w<cr>", s)
for i = 1, 7 do
	map("n", "<leader>" .. i, i .. "gt", s)
end
map("n", "<leader>tc", "<cmd>tabnew<cr>", s)
map("n", "<leader>tp", "<cmd>tabprev<cr>", s)
map("n", "<leader>tn", "<cmd>tabnext<cr>", s)

map("n", "<leader>ca", vim.lsp.buf.code_action, s)

-- Toggle comment with built-in gc/gcc (<C-/> arrives as <C-_> in terminals)
for _, lhs in ipairs { "<C-/>", "<C-_>" } do
	map("n", lhs, "gcc", { remap = true })
	map("x", lhs, "gc", { remap = true })
end

-- Terminal: window navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", s)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", s)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", s)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", s)

-- Visual: keep selection after indenting; move selected lines down/up
map("v", "<", "<gv", s)
map("v", ">", ">gv", s)
map("v", "J", ":m '>+1<cr>gv=gv", s)
map("v", "K", ":m '<-2<cr>gv=gv", s)

-- Command line: <C-j>/<C-k> move in the completion menu when it's open;
-- otherwise <C-k> deletes to end of line (emacs style; other emacs keys are in plugin/emacs-move.vim)
map("c", "<C-j>", function()
	return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true })
map("c", "<C-k>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-p>"
	end
	vim.fn.setcmdline(vim.fn.getcmdline():sub(1, vim.fn.getcmdpos() - 1))
	return ""
end, { expr = true })
