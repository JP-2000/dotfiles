-- What: grug-far.nvim provides project-wide search and replacement.
-- How: Use <leader>sr to open a buffer where search terms and replacements can be edited.
-- Why: Matching lines can be reviewed in one place before applying replacements.

return {
	"MagicDuck/grug-far.nvim",

	config = function()
		require("grug-far").setup()
	end,

	keys = {
		{
			"<leader>sr",
			"<cmd>GrugFar<cr>",
			desc = "Find and replace",
		},
	},
}
