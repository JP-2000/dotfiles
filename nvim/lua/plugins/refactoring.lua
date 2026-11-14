-- What: refactoring.nvim provides tools for restructuring code.
-- How: Select code in Visual mode and press <leader>re to extract it into a function.
-- Why: Function extraction helps turn a large block into a smaller, reusable piece.

return {
	"ThePrimeagen/refactoring.nvim",
	lazy = false,
	dependencies = {
		"lewis6991/async.nvim",
	},
	keys = {
		{
			"<leader>re",
			function()
				return require("refactoring").extract_func()
			end,
			mode = "x",
			expr = true,
			desc = "Extract function",
		},
	},
}
