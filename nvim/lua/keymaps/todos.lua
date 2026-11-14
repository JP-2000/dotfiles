-- Manage todos
-- Add todo below
vim.keymap.set("n", "<leader>Tj", "o- [ ] ", {
	desc = "Todo: Add below",
})

-- Add todo above
vim.keymap.set("n", "<leader>Tk", "O- [ ] ", {
	desc = "Todo: Add above",
})

-- Toggle todo done / undone
vim.keymap.set("n", "<leader>Tx", function()
	local line = vim.api.nvim_get_current_line()

	if line:match("%- %[ %]") then
		line = line:gsub("%- %[ %]", "- [x]", 1)
	elseif line:match("%- %[x%]") then
		line = line:gsub("%- %[x%]", "- [ ]", 1)
	end

	vim.api.nvim_set_current_line(line)
end, {
	desc = "Todo: Toggle",
})

-- Insert today's date
vim.keymap.set("n", "<leader>Td", function()
	vim.api.nvim_put({ os.date("%Y-%m-%d") }, "c", true, true)
end, {
	desc = "Todo: Insert date",
})
