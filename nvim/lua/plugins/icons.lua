-- What: mini.icons supplies icons for file types and other editor items.
-- How: It loads at startup with a higher priority than the theme and Snacks.
-- Why: Plugins that use mini.icons can access it when they build their interfaces.

return {
	{
		"nvim-mini/mini.icons",
		version = false,
		lazy = false,
		priority = 1100,
		opts = {},
	},
}
