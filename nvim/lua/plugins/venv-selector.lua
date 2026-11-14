-- What: venv-selector.nvim lets you choose a Python virtual environment.
-- How: It loads for Python files, and .v opens :VenvSelect.
-- Why: Selecting an environment lets Python tooling use the project's installed packages.

return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		-- Telescope is available as a picker for the environment list.
		{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
	},
	ft = "python",
	keys = {
		{ ".v", "<cmd>VenvSelect<cr>", desc = "Select virtualenv" },
	},
	opts = {
		-- Use the plugin's default behavior and environment searches.
		options = {},
		search = {},
	},
}
