-- Tab line: " [1] filename + " per tab; the + marks unsaved changes. Close button on the right.

-- Name shown for a buffer
local function buf_label(buf)
	local name = vim.api.nvim_buf_get_name(buf)
	if not vim.bo[buf].modifiable then
		if vim.bo[buf].buftype == "quickfix" then
			return "[Quickfix]"
		end
		return name == "" and "[No Name]" or "-" .. vim.fn.fnamemodify(name, ":t")
	end
	if name == "" then
		return "[No Name]"
	end
	local full = vim.fn.fnamemodify(name, ":p")
	local tail = vim.fn.fnamemodify(full, ":t")
	if tail == "" then -- a directory: show <dirname>
		return "<" .. vim.fn.fnamemodify(full, ":h:t") .. ">"
	end
	return tail
end

function _G.user_tabline()
	local s = ""
	local current = vim.api.nvim_get_current_tabpage()
	for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
		local label = "[" .. i .. "] " .. buf_label(buf) .. (vim.bo[buf].modified and " +" or "")
		s = s
			.. (tab == current and "%#TabLineSel#" or "%#TabLine#")
			.. "%" .. i .. "T" -- click to switch to this tab
			.. " " .. label:gsub("%%", "%%%%") .. " "
	end
	s = s .. "%#TabLineFill#%T"
	if #vim.api.nvim_list_tabpages() > 1 then
		s = s .. "%=%#TabLine#%999XX" -- click to close the current tab
	end
	return s
end

vim.o.tabline = "%!v:lua.user_tabline()"
