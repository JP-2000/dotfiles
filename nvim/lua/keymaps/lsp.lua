local function code_action()
	if vim.bo.filetype ~= "python" then
		vim.lsp.buf.code_action()
		return
	end

	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(win)
	local mode = vim.fn.mode()
	local is_visual = mode == "v" or mode == "V" or mode == "\22"
	local selection_start = vim.fn.getpos("v")

	if is_visual then
		vim.cmd.normal({ args = { "\27" }, bang = true })
	end

	local import_label = is_visual and "Add import for selection" or "Add import under cursor"
	vim.ui.select({ import_label, "LSP code actions" }, {
		prompt = "Python actions",
	}, function(choice)
		if choice == nil then
			return
		end
		if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
			return
		end

		vim.api.nvim_set_current_win(win)
		-- Restore the original selection after the action picker closes.
		if is_visual then
			vim.fn.setpos(".", selection_start)
			vim.cmd.normal({ args = { mode }, bang = true })
		end
		vim.api.nvim_win_set_cursor(win, cursor)

		if choice == "LSP code actions" then
			vim.lsp.buf.code_action()
		elseif is_visual then
			require("python_import.api").add_import_current_selection_and_notify()
		else
			require("python_import.api").add_import_current_word_and_notify()
		end
	end)
end

vim.keymap.set({ "n", "v" }, "c.", code_action, {
	desc = "Quick fix / code action",
})

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
