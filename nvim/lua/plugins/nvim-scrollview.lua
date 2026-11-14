-- What: nvim-scrollview adds a scrollbar with markers for useful locations in a file.
-- How: The current window shows search matches, marks, and error or warning diagnostics.
-- Why: The markers help locate relevant lines beyond the visible part of the buffer.

return {
	"dstein64/nvim-scrollview",
	opts = {
		current_only = true,

		signs_on_startup = {
			"diagnostics",
			"search",
			"marks",
		},

		diagnostics_severities = {
			vim.diagnostic.severity.ERROR,
			vim.diagnostic.severity.WARN,
		},
	},
}
