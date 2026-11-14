-- Tree-sitter incremental selection

-- Start a selection around the current syntax node.
-- Press <leader>v again in Visual mode to expand outward.
vim.keymap.set("n", "<leader>is", function()
	vim.treesitter.select("parent")
end, { desc = "Start incremental selection" })

-- Expand the current selection to the parent syntax node.
vim.keymap.set("x", "<leader>is", function()
	vim.treesitter.select("parent")
end, { desc = "Increment selection" })

-- Shrink the current selection to the child syntax node.
vim.keymap.set("x", "<leader>ds", function()
	vim.treesitter.select("child")
end, { desc = "Decrement selection" })
