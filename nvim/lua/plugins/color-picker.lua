-- What: ccc.nvim provides a color picker and highlights color values in files.
-- How: Highlights appear automatically, and <leader>pc opens the color picker.
-- Why: Seeing and choosing colors directly makes theme and style edits easier.

return {
	"uga-rosa/ccc.nvim",
	config = function()
		require("ccc").setup({
			highlighter = {
				auto_enable = true,
				lsp = true,
			},
		})

		vim.keymap.set("n", "<leader>pc", "<cmd>CccPick<cr>", {
			desc = "Picke Color",
		})
	end,
}
