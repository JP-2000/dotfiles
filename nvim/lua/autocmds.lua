vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
	desc = "Enable English spell-checking in prose files",
	callback = function()
		local prose_filetypes = { "markdown", "text", "tex", "plaintex" }
		local is_prose = vim.tbl_contains(prose_filetypes, vim.bo.filetype)

		-- Spell-checking is window-local, so reset it when switching to code.
		vim.opt_local.spell = is_prose
		if is_prose then
			vim.opt_local.spelllang = "en"
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Disable smooth scrolling in Markdown buffers",
	pattern = "markdown",
	callback = function(args)
		vim.b[args.buf].snacks_scroll = false
	end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
	pattern = "*.pdf",
	callback = function(args)
		vim.fn.jobstart({ "xdg-open", args.file }, { detach = true })
		vim.cmd("bdelete")
	end,
})
