-- What: Everforest supplies the editor's color scheme.
-- How: It loads at startup and selects the theme's soft background contrast.
-- Why: Loading the theme early gives the editor a consistent appearance from startup.

return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.everforest_background = "soft"
		vim.cmd.colorscheme("everforest")
	end,
}
