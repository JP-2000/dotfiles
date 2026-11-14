-- What: image.nvim renders images inside Neovim using Kitty's graphics protocol.
-- How: It handles image files and the custom dashboard image drawn in snacks.lua.
-- Why: Images can be viewed alongside editor content without opening a separate viewer.

return {
	"3rd/image.nvim",
	build = false,
	lazy = false,
	---@type table
	opts = {
		backend = "kitty",
		kitty_method = "unicode-placeholders",
		-- Use ImageMagick's command-line tools for image processing.
		processor = "magick_cli",
		window_overlap_clear_enabled = true,

		-- Keep document integrations disabled here; this instance handles files and explicit renders.
		integrations = {
			markdown = { enabled = false },
			asciidoc = { enabled = false },
			neorg = { enabled = false },
			rst = { enabled = false },
			typst = { enabled = false },
			html = { enabled = false },
			css = { enabled = false },
		},

		-- Hide images when another tmux window is active.
		tmux_show_only_in_active_window = true,

		hijack_file_patterns = {
			"*.png",
			"*.jpg",
			"*.jpeg",
			"*.gif",
			"*.webp",
			"*.avif",
		},
	},
	config = function(_, opts)
		local tmux = require("image/utils/tmux")

		-- Avoid treating tmux lookup errors as filenames when clearing images.
		tmux.get_pane_tty = function()
			local pane = vim.env.TMUX_PANE
			if not tmux.is_tmux or not pane or pane == "" then
				return nil
			end

			local result = vim.fn.system({
				"tmux",
				"display-message",
				"-p",
				"-t",
				pane,
				"#{pane_tty}",
			})
			if vim.v.shell_error ~= 0 then
				return nil
			end

			local tty = vim.trim(result)
			if not tty:match("^/dev/") then
				return nil
			end

			return tty
		end

		require("image").setup(opts)
	end,
}
