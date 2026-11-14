-- What: lazydev.nvim supplies Lua type information for Neovim configuration and plugins.
-- How: It loads for Lua files and also provides a completion source configured in blink.lua.
-- Why: Neovim-specific types make API completion and documentation more useful.

return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			-- Load the libuv types only when the file refers to vim.uv.
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
