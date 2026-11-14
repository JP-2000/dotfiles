-- What: nvim-lint reports Python code issues through Ruff.
-- How: Diagnostics refresh after edits and saves; <leader>L also refreshes them manually.
-- Why: Feedback appears while editing, and the same shortcut requests Clippy checks for Rust.

return {
	{
		"mfussenegger/nvim-lint",

		event = {
			"BufReadPre",
			"BufNewFile",
		},

		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "ruff" },
			}

			local group = vim.api.nvim_create_augroup("lint_diagnostics", { clear = true })
			-- Track the latest delayed refresh separately for each buffer.
			local pending = {}

			local function refresh_diagnostics(bufnr)
				-- An immediate refresh also cancels any delayed refresh for this buffer.
				pending[bufnr] = nil

				if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
					return
				end

				vim.api.nvim_buf_call(bufnr, function()
					lint.try_lint()
				end)
			end

			-- Wait for a short pause in typing before running Ruff again.
			vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
				group = group,
				callback = function(event)
					local bufnr = event.buf
					if not lint.linters_by_ft[vim.bo[bufnr].filetype] then
						return
					end

					-- Only the most recent edit may trigger the delayed refresh.
					local request = {}
					pending[bufnr] = request
					vim.defer_fn(function()
						if pending[bufnr] == request then
							refresh_diagnostics(bufnr)
						end
					end, 400)
				end,
			})

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = group,
				callback = function(event)
					refresh_diagnostics(event.buf)
				end,
			})

			vim.api.nvim_create_autocmd("BufUnload", {
				group = group,
				callback = function(event)
					pending[event.buf] = nil
				end,
			})

			vim.keymap.set("n", "<leader>L", function()
				local bufnr = vim.api.nvim_get_current_buf()
				local filetype = vim.bo[bufnr].filetype

				if filetype == "rust" then
					-- Rust diagnostics come from rust-analyzer rather than nvim-lint.
					local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
					local client = clients[1]
					if not client then
						vim.notify("rust-analyzer is not attached", vim.log.levels.INFO)
						return
					end

					if vim.bo[bufnr].modified then
						-- Clippy reads files from disk; saving triggers check-on-save.
						vim.cmd.update()
					else
						client:notify("rust-analyzer/runFlycheck", {
							textDocument = { uri = vim.uri_from_bufnr(bufnr) },
						})
					end
					return
				end

				if not lint.linters_by_ft[filetype] then
					vim.notify("No linter configured for " .. filetype, vim.log.levels.INFO)
					return
				end

				refresh_diagnostics(bufnr)
			end, { desc = "Refresh diagnostics" })
		end,
	},
}
