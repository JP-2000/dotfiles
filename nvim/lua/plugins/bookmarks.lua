-- What: bookmarks.nvim saves named locations in files.
-- How: It stores bookmarks in SQLite and uses the mappings in lua/keymaps/bookmarks.lua.
-- Why: Saved locations make it easier to return to important code across sessions.

return {
	{
		"LintaoAmons/bookmarks.nvim",
		tag = "v4.0.0",

		dependencies = {
			{ "kkharji/sqlite.lua" },
			{ "folke/snacks.nvim" },
		},
		config = function()
			local opts = {}
			-- Setup also initializes the SQLite database used to store bookmarks.
			require("bookmarks").setup(opts)
		end,
	},
}
