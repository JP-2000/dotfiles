-- Copy path relative to project root
vim.keymap.set("n", "<leader>cp", function()
	local file = vim.fn.expand("%:p")
	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

	if vim.v.shell_error ~= 0 or not root then
		root = vim.fn.getcwd()
	end

	local path = file:sub(#root + 2)

	vim.fn.setreg("+", path)
	vim.notify("Copied path: " .. path)
end, { desc = "Copy Path" })

-- Copy absolute path
vim.keymap.set("n", "<leader>cap", function()
	local path = vim.fn.expand("%:p")

	vim.fn.setreg("+", path)
	vim.notify("Copied absolute path: " .. path)
end, { desc = "Copy Absolute Path" })

vim.keymap.set("n", "<leader>cr", function()
	vim.cmd("source $MYVIMRC")
	vim.notify("Neovim config reloaded")
end, { desc = "Reload config" })

vim.keymap.set("n", "<leader>qr", "<cmd>restart<cr>", {
	desc = "Restart and restore session",
})
