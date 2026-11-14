-- What: live-preview.nvim shows a live document preview in a web browser.
-- How: Use <leader>p to start the preview and <leader>P to close it.
-- Why: The browser shows how a Markdown document renders while it is being edited.

return {
	"brianhuster/live-preview.nvim",
	tag = "v0.9.7",
	cmd = "LivePreview",
	keys = {
		{
			"<leader>p",
			"<cmd>LivePreview start<cr>",
			mode = "n",
			desc = "Start Markdown preview",
		},
		{
			"<leader>P",
			"<cmd>LivePreview close<cr>",
			mode = "n",
			desc = "Stop Markdown preview",
		},
	},
}
