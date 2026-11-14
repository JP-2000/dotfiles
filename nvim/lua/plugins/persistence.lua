-- What: persistence.nvim saves and restores editor sessions.
-- How: Use <leader>qs to restore the current session or <leader>qS to choose a saved one.
-- Why: Restoring open files and window layouts makes it easier to resume work.

local function list_sessions()
	local items = {}

	for _, session in ipairs(require("persistence").list()) do
		-- Decode the directory and optional Git branch stored in the session filename.
		local name = vim.fn.fnamemodify(session, ":t:r")
		local parts = vim.split(name, "%%", { plain = true })
		local directory = parts[1]:gsub("%%", "/")
		local branch = "default"

		if parts[2] then
			branch = parts[2]:gsub("%%", "/")
		end

		items[#items + 1] = {
			text = vim.fn.fnamemodify(directory, ":~") .. " [" .. branch .. "]",
			session = session,
			directory = directory,
		}
	end

	return items
end

local function restore_session(picker, item)
	if not item then
		return
	end

	picker:close()

	-- Wait for the picker windows to close before restoring the session layout.
	vim.schedule(function()
		local persistence = require("persistence")
		local ok, err = pcall(function()
			vim.fn.chdir(item.directory)
			persistence.fire("LoadPre")
			vim.cmd.source(vim.fn.fnameescape(item.session))
			persistence.fire("LoadPost")
		end)

		if not ok then
			vim.notify("Could not restore session:\n" .. tostring(err), vim.log.levels.ERROR)
		end
	end)
end

local function delete_session(picker, item)
	if not item then
		return
	end

	local deleted, err = vim.uv.fs_unlink(item.session)
	if not deleted then
		vim.notify("Could not delete session:\n" .. err, vim.log.levels.ERROR)
		return
	end

	local persistence = require("persistence")
	if item.session == persistence.current() then
		-- Stop automatic saving so the deleted session is not created again on exit.
		persistence.stop()
		vim.notify("Session deleted; automatic session saving stopped.")
	end

	-- Diffview uses this reference to save its companion file on exit.
	if item.session == vim.v.this_session then
		vim.v.this_session = ""
	end

	-- Remove the saved Diffview state together with its session.
	local sidecar = item.session .. ".diffview.json"
	local sidecar_deleted, sidecar_err, sidecar_code = vim.uv.fs_unlink(sidecar)
	if not sidecar_deleted and sidecar_code ~= "ENOENT" then
		vim.notify("Could not delete session companion:\n" .. sidecar_err, vim.log.levels.ERROR)
	end

	picker:refresh()
end

local function select_session()
	Snacks.picker({
		title = "Sessions",
		layout = "select",
		finder = list_sessions,
		format = "text",
		show_empty = true,
		confirm = restore_session,
		actions = {
			delete_session = {
				action = delete_session,
				desc = "Delete session",
			},
		},
		win = {
			input = {
				keys = {
					["<c-d>"] = { "delete_session", mode = { "i", "n" } },
				},
			},
			list = {
				keys = {
					["<c-d>"] = "delete_session",
				},
			},
		},
	})
end

return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		config = function(_, opts)
			require("persistence").setup(opts)

			-- Close explorer windows before saving so temporary picker buffers are not restored.
			vim.api.nvim_create_autocmd("User", {
				group = vim.api.nvim_create_augroup("persistence_explorer", { clear = true }),
				pattern = "PersistenceSavePre",
				callback = function()
					for _, explorer in ipairs(Snacks.picker.get({ source = "explorer" })) do
						explorer:close()
						-- Picker cleanup is scheduled; close the layout before the session is saved.
						explorer.layout:close()
					end
				end,
			})
		end,
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore session",
			},
			{
				"<leader>qS",
				select_session,
				desc = "Select session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore last session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't save session",
			},
		},
	},
}
