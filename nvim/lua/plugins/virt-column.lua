-- What: virt-column.nvim draws a thin vertical guide at a chosen text column.
-- How: The guide appears at column 101 using the character configured below.
-- Why: It provides a visual reference for keeping lines within 100 columns.

return {
	"IronGeek/virt-column.nvim",
	-- Fix the row-index mismatch that leaks extmarks on each redraw.
	-- Upstream fix: https://github.com/lukas-reineke/virt-column.nvim/pull/51
	branch = "fix/off-by-one",
	commit = "f4a2872d80d7b5666de1c1e1c345a9e71ebfcde9",

	opts = {
		char = "▏",
		virtcolumn = "101",
	},
}
