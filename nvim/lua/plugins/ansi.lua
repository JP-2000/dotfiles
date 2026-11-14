-- What: ansi.nvim displays the colors encoded in terminal output.
-- How: It automatically handles log and ANSI files, as well as input piped into Neovim.
-- Why: Colored logs are easier to read when their escape codes are rendered as colors.

return {
	"0xferrous/ansi.nvim",
	config = function()
		require("ansi").setup({
			auto_enable = true,
			auto_enable_stdin = true,
			filetypes = { "log", "ansi" },
			theme = "terminal",
		})
	end,
}
