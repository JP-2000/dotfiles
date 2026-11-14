--window management
-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Splits
vim.keymap.set("n", "<C-w>-", "<C-w>s", { desc = "Split Window Below" })
vim.keymap.set("n", "<C-w>|", "<C-w>v", { desc = "Split Window Right" })

vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Window commands from terminal" })
