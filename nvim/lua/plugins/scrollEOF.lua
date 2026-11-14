-- What: scrollEOF.nvim keeps space below the cursor near the end of a file.
-- How: It extends scrolloff behavior past the last line, including in Insert mode.
-- Why: The final lines can stay away from the bottom edge while they are being edited.

return {
	"Aasim-A/scrollEOF.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		insert_mode = true,
		-- Apply this behavior to editing windows rather than floating windows or Snacks panels.
		floating = false,
		disabled_filetypes = {
			"terminal",
			"snacks_dashboard",
			"snacks_picker_input",
			"snacks_picker_list",
			"snacks_picker_preview",
		},
	},
}
