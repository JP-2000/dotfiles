-- What: diffview-plus.nvim provides views for Git changes and file history.
-- How: Use gfd to toggle the diff view and gfh to inspect the current file's history.
-- Why: A file tree and switchable diff layouts make changes easier to review together.

local statusline_hidden = true

local function set_diff_highlights()
	local line_background = "#454039"
	local text_background = "#605039"

	if vim.o.background == "light" then
		line_background = "#f1e4c5"
		text_background = "#e4cea0"
	end

	vim.api.nvim_set_hl(0, "DiffviewDiffChange", { bg = line_background })
	vim.api.nvim_set_hl(0, "DiffviewDiffText", { bg = text_background })
	vim.api.nvim_set_hl(0, "DiffviewDiffTextInline", { bg = text_background })
end

local function has_horizontal_split(layout)
	if layout[1] == "col" then
		return true
	end

	if layout[1] == "leaf" then
		return false
	end

	for _, child in ipairs(layout[2]) do
		if has_horizontal_split(child) then
			return true
		end
	end

	return false
end

local function blend_statusline()
	vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
	vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
	vim.api.nvim_set_hl(0, "StatusLineTerm", { link = "Normal" })
	vim.api.nvim_set_hl(0, "StatusLineTermNC", { link = "Normal" })
end

local function update_statusline()
	if statusline_hidden then
		if has_horizontal_split(vim.fn.winlayout()) then
			-- Horizontal splits still need a bottom row when the statusline is hidden.
			-- Keep a blank global statusline and blend it into the window background.
			vim.o.laststatus = 3
			vim.o.statusline = " "
			blend_statusline()
		else
			-- Remove the statusline when the layout does not need that extra row.
			vim.o.laststatus = 0
		end
	else
		-- Show the statusline content with the same background as the window.
		vim.o.laststatus = 3
		vim.o.statusline = ""
		blend_statusline()
	end
end

return {
	{
		"dlyongemallo/diffview-plus.nvim",

		cmd = {
			"DiffviewOpen",
			"DiffviewToggle",
			"DiffviewClose",
			"DiffviewFileHistory",
		},

		opts = {
			enhanced_diff_hl = true,

			view = {
				default = {
					layout = "diff2_horizontal",
				},
				cycle_layouts = {
					default = { "diff2_horizontal", "diff1_inline" },
				},
			},

			file_panel = {
				listing_style = "tree",
				win_config = {
					position = "left",
					width = 35,
				},
			},

			hooks = {
				view_enter = function()
					statusline_hidden = true
					update_statusline()
				end,

				view_leave = function()
					statusline_hidden = true
					update_statusline()
				end,

				view_closed = function()
					statusline_hidden = true
					update_statusline()
				end,
			},
		},

		config = function(_, opts)
			require("diffview").setup(opts)
			set_diff_highlights()

			-- Apply after Diffview rebuilds its highlights on theme changes.
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("DiffviewHighlights", { clear = true }),
				callback = set_diff_highlights,
			})
		end,

		keys = {
			{
				"gfd",
				"<cmd>DiffviewToggle<cr>",
				desc = "Git File Diff",
			},
			{
				"gfh",
				"<cmd>DiffviewFileHistory %<cr>",
				desc = "Git File History",
			},
			{
				"gfc",
				"<cmd>DiffviewClose<cr>",
				desc = "Git Close Diffview",
			},
			{
				"gfH",
				"<cmd>DiffviewFileHistory<cr>",
				desc = "Git Repository History",
			},
			{
				"gfs",
				"<cmd>DiffviewOpen --cached<cr>",
				desc = "Git Staged Diff",
			},
		},
	},
}
