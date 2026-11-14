local function format_diagnostic(diagnostic)
	local filename = vim.fn.expand("%:.")

	local severity = vim.diagnostic.severity[diagnostic.severity] or "UNKNOWN"
	local source = diagnostic.source or "Unknown"
	local code = diagnostic.code or "N/A"

	return string.format(
		"File: %s\n"
			.. "Line: %d\n"
			.. "Column: %d\n"
			.. "Severity: %s\n"
			.. "Source: %s\n"
			.. "Code: %s\n"
			.. "Message: %s",
		filename,
		diagnostic.lnum + 1,
		diagnostic.col + 1,
		severity,
		source,
		code,
		diagnostic.message
	)
end

local separator = "\n" .. string.rep("-", 40) .. "\n\n"

-- Copy diagnostics on current line
vim.keymap.set("n", "<leader>cd", function()
	local line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diagnostics = vim.diagnostic.get(0, { lnum = line })

	if #diagnostics == 0 then
		vim.notify("No diagnostics on current line")
		return
	end

	local messages = vim.tbl_map(format_diagnostic, diagnostics)

	vim.fn.setreg("+", table.concat(messages, separator))
	vim.notify("Line diagnostics copied")
end, { desc = "Copy line diagnostics" })

-- Copy all diagnostics in current buffer
vim.keymap.set("n", "<leader>cD", function()
	local diagnostics = vim.diagnostic.get(0)

	if #diagnostics == 0 then
		vim.notify("No diagnostics in buffer")
		return
	end

	local messages = vim.tbl_map(format_diagnostic, diagnostics)

	vim.fn.setreg("+", table.concat(messages, separator))
	vim.notify("Buffer diagnostics copied")
end, { desc = "Copy buffer diagnostics" })
