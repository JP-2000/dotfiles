-- Paste over a visual selection without replacing the unnamed/clipboard register.
vim.keymap.set("x", "p", "P")

-- Keep selection after indenting
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent selection" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
