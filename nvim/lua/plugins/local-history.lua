-- What: vim-local-history keeps local snapshots of edited files.
-- How: Use <leader>lh to open the history view and inspect earlier versions.
-- Why: Local snapshots help recover edits that have not been captured in Git commits.

return {
	{
		"dinhhuy258/vim-local-history",

		lazy = false,
		-- Register the plugin's remote provider after installation or an update.
		build = ":UpdateRemotePlugins",

		keys = {
			{
				"<leader>lh",
				"<cmd>LocalHistoryToggle<CR>",
				desc = "Local History",
			},
		},
	},
}
