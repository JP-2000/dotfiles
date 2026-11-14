-- What: nvim-autopairs inserts matching brackets and quotes while typing.
-- How: It loads when entering Insert mode and uses the plugin's default rules.
-- Why: It reduces the need to type and keep track of closing characters.

return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = true,
}
