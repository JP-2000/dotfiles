-- staus bar
local statusline_hidden = true

local function has_horizontal_split(layout)
	if layout[1] == "col" then
		return true
	end

	if layout[1] == "leaf" then
		return false
	end

	for _, child in ipairs(layout[2]) do
		if has_horizontal_split(child) then
			return true
		end
	end

	return false
end

local function blend_statusline()
	vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
	vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
	vim.api.nvim_set_hl(0, "StatusLineTerm", { link = "Normal" })
	vim.api.nvim_set_hl(0, "StatusLineTermNC", { link = "Normal" })
end

local function update_statusline()
	if statusline_hidden then
		if has_horizontal_split(vim.fn.winlayout()) then
			-- Limitation: horizontal splits need one bottom row; laststatus=0 leaves awkward
			-- vertical space.
			-- Keep one row so horizontal splits look correct
			vim.o.laststatus = 3
			vim.o.statusline = " "
			blend_statusline()
		else
			-- Remove statusline completely
			vim.o.laststatus = 0
		end
	else
		-- Show statusline content, but no highlighted background
		vim.o.laststatus = 3
		vim.o.statusline = ""
		blend_statusline()
	end
end

vim.keymap.set("n", "<leader>bb", function()
	statusline_hidden = not statusline_hidden
	update_statusline()
end, { desc = "Toggle status bar" })

vim.api.nvim_create_autocmd({ "WinNew", "WinClosed" }, {
	callback = function()
		vim.schedule(update_statusline)
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.schedule(function()
			blend_statusline()
			update_statusline()
		end)
	end,
})

update_statusline()
