-- What: ipynb.nvim opens Jupyter notebooks as editable cells with inline output.
-- How: Open an .ipynb file, start a kernel with :NotebookKernelStart, and run :NotebookExecuteCell.
-- Why: Notebook code and results can be inspected using the same editor as other project files.

-- Prefer the Python environment stored in Neovim's data directory when it is available.
local notebook_python = vim.fn.stdpath("data") .. "/python/bin/python"

return {
	"ajbucci/ipynb.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"neovim/nvim-lspconfig",
		"folke/snacks.nvim",
	},
	opts = {
		kernel = {
			-- A nil value lets the plugin search for a project environment or system Python.
			python_path = vim.fn.executable(notebook_python) == 1 and notebook_python or nil,
		},
		shadow = {
			-- Keep the combined code buffer in the workspace so the LSP can resolve project imports.
			location = "workspace",
		},
	},
}
