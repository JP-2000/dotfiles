-- What: gitsigns.nvim marks lines that differ from the Git index.
-- How: Use ]c and [c to move between changes and <leader>h mappings to inspect or stage them.
-- Why: Small changes can be reviewed and staged directly in the buffer being edited.

return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- Keep these mappings local to buffers where Gitsigns is active.
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, lhs, rhs, description)
					vim.keymap.set(mode, lhs, rhs, {
						buffer = bufnr,
						desc = description,
					})
				end

				local function next_hunk()
					-- Preserve Neovim's own change navigation inside diff windows.
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
						return
					end

					gitsigns.nav_hunk("next")
				end

				local function previous_hunk()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
						return
					end

					gitsigns.nav_hunk("prev")
				end

				local function stage_selected_hunk()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end

				local function reset_selected_hunk()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end

				local function blame_line()
					gitsigns.blame_line({ full = true })
				end

				local function diff_previous_revision()
					gitsigns.diffthis("~")
				end

				local function add_all_hunks_to_quickfix()
					gitsigns.setqflist("all")
				end

				map("n", "]c", next_hunk, "Git: Next hunk")
				map("n", "[c", previous_hunk, "Git: Previous hunk")

				map("n", "<leader>hs", gitsigns.stage_hunk, "Git: Stage hunk")
				map("n", "<leader>hr", gitsigns.reset_hunk, "Git: Reset hunk")
				map("v", "<leader>hs", stage_selected_hunk, "Git: Stage selected hunk")
				map("v", "<leader>hr", reset_selected_hunk, "Git: Reset selected hunk")

				map("n", "<leader>hS", gitsigns.stage_buffer, "Git: Stage buffer")
				map("n", "<leader>hR", gitsigns.reset_buffer, "Git: Reset buffer")
				map("n", "<leader>hp", gitsigns.preview_hunk, "Git: Preview hunk")
				map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Git: Preview hunk inline")
				map("n", "<leader>hb", blame_line, "Git: Blame line")
				map("n", "<leader>hd", gitsigns.diffthis, "Git: Diff this")
				map("n", "<leader>hD", diff_previous_revision, "Git: Diff previous revision")
				map("n", "<leader>hQ", add_all_hunks_to_quickfix, "Git: Add all hunks to quickfix")
				map("n", "<leader>hq", gitsigns.setqflist, "Git: Add hunks to quickfix")

				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Git: Toggle line blame")
				map("n", "<leader>tw", gitsigns.toggle_word_diff, "Git: Toggle word diff")

				map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git: Select hunk")
			end,
		},
	},
}
