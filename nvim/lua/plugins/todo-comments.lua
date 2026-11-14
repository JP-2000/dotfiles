-- What: todo-comments.nvim highlights TODO, FIXME, and NOTE markers in comments.
-- How: Use <leader>ac mappings to insert markers and <leader>lc mappings to find them.
-- Why: Tasks and explanations remain easy to locate alongside the code they describe.

-- Keep searches rooted here until <leader>lcd selects the current file's directory.
local comments_cwd = vim.fn.getcwd()

-- Insert a comment above the current line using its indentation and filetype's comment syntax.
local function add_comment(marker)
	local commentstring = vim.bo.commentstring

	if commentstring == "" then
		commentstring = "# %s"
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_get_current_line()
	local indent = line:match("^%s*") or ""

	local text = indent .. commentstring:format(marker .. ":  ")

	vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { text })
	vim.api.nvim_win_set_cursor(0, { row, #text - 1 })
end

return {
	{
		"folke/todo-comments.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function(_, opts)
			require("todo-comments").setup(opts)
			-- Extend highlighting to continuation lines even when the marker is above the viewport.
			require("config.todo-comments").setup()
		end,

		opts = {
			-- Use only the three markers listed here rather than merging the default keywords.
			merge_keywords = false,

			keywords = {
				TODO = {
					icon = " ",
					color = "info",
				},
				FIXME = {
					icon = " ",
					color = "error",
				},
				NOTE = {
					icon = " ",
					color = "hint",
				},
			},
		},

		keys = {
			-- Insert one of the configured comment markers.
			{
				"<leader>act",
				function()
					add_comment("TODO")
				end,
				desc = "Add TODO comment",
			},
			{
				"<leader>acf",
				function()
					add_comment("FIXME")
				end,
				desc = "Add FIXME comment",
			},
			{
				"<leader>acn",
				function()
					add_comment("NOTE")
				end,
				desc = "Add NOTE comment",
			},

			-- Set the directory used by comment searches that span multiple files.
			{
				"<leader>lcd",
				function()
					local file = vim.api.nvim_buf_get_name(0)

					if file == "" then
						vim.notify("Current buffer has no file")
						return
					end

					comments_cwd = vim.fn.fnamemodify(file, ":p:h")
					vim.notify("Comment directory: " .. comments_cwd)
				end,
				desc = "Set comment directory",
			},

			-- Lowercase suffixes search the chosen directory; uppercase suffixes search the current file.
			{
				"<leader>lcc",
				function()
					Snacks.picker.todo_comments({
						cwd = comments_cwd,
						keywords = { "TODO", "FIXME", "NOTE" },
					})
				end,
				desc = "List all comments",
			},
			{
				"<leader>lcC",
				function()
					Snacks.picker.todo_comments({
						keywords = { "TODO", "FIXME", "NOTE" },
						filter = { buf = true },
					})
				end,
				desc = "List all comments in current file",
			},

			-- Find TODO comments.
			{
				"<leader>lct",
				function()
					Snacks.picker.todo_comments({
						cwd = comments_cwd,
						keywords = { "TODO" },
					})
				end,
				desc = "List TODO comments",
			},
			{
				"<leader>lcT",
				function()
					Snacks.picker.todo_comments({
						keywords = { "TODO" },
						filter = { buf = true },
					})
				end,
				desc = "List TODO comments in current file",
			},

			-- Find FIXME comments.
			{
				"<leader>lcf",
				function()
					Snacks.picker.todo_comments({
						cwd = comments_cwd,
						keywords = { "FIXME" },
					})
				end,
				desc = "List FIXME comments",
			},
			{
				"<leader>lcF",
				function()
					Snacks.picker.todo_comments({
						keywords = { "FIXME" },
						filter = { buf = true },
					})
				end,
				desc = "List FIXME comments in current file",
			},

			-- Find NOTE comments.
			{
				"<leader>lcn",
				function()
					Snacks.picker.todo_comments({
						cwd = comments_cwd,
						keywords = { "NOTE" },
					})
				end,
				desc = "List NOTE comments",
			},
			{
				"<leader>lcN",
				function()
					Snacks.picker.todo_comments({
						keywords = { "NOTE" },
						filter = { buf = true },
					})
				end,
				desc = "List NOTE comments in current file",
			},
		},
	},
}
