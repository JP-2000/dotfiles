-- Buffers
vim.keymap.set("n", "<C-b>h", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-b>l", "<cmd>bnext<CR>", { desc = "Next buffer" })

vim.keymap.set("n", "<C-b>b", function()
	Snacks.picker.buffers()
end, { desc = "Browse buffers" })

vim.keymap.set("n", "<C-b>d", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
