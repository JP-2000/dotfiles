-- What: blink.cmp provides completion suggestions while typing.
-- How: It combines LSP, path, snippet, buffer, and LazyDev sources; Ctrl-y accepts a suggestion.
-- Why: These sources make code, filenames, and Neovim APIs available in one completion menu.

return {
	"saghen/blink.cmp",
	-- friendly-snippets supplies the snippets offered by the completion menu.
	dependencies = { "rafamadriz/friendly-snippets" },

	-- Use a 1.x release so Blink can download a matching prebuilt fuzzy matcher.
	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- Ctrl-space opens the menu or its documentation, and Ctrl-n/Ctrl-p move through suggestions.
		-- Ctrl-y accepts the selected suggestion, and Ctrl-e hides the menu.
		keymap = { preset = "default" },

		appearance = {
			-- Match icon spacing to a Nerd Font Mono font.
			nerd_font_variant = "mono",
		},

		-- Show documentation only when requested with Ctrl-space.
		completion = { documentation = { auto_show = false } },

		-- Offer Neovim-aware Lua suggestions alongside the usual completion sources.
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- Rank LazyDev suggestions above otherwise similar completion items.
					score_offset = 100,
				},
			},
		},
		-- Prefer the Rust matcher, but fall back to Lua with a warning if it is unavailable.
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	-- Allow other plugin specs to add sources without replacing this list.
	opts_extend = { "sources.default" },
}
