local M = {}

function M.root(directory)
	if not directory then
		local file = vim.api.nvim_buf_get_name(0)
		directory = vim.fn.getcwd()
		if file ~= "" then
			directory = vim.fs.dirname(file)
		end
	end

	return vim.fs.root(directory, { "ols.json", ".git" }) or directory
end

function M.run(name)
	vim.cmd.update()
	require("overseer").run_task({
		name = name,
		search_params = { dir = M.root(), filetype = "odin" },
	})
end

return M
