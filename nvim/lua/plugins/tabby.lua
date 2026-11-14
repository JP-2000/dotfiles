-- What: tabby.nvim displays Neovim tab pages in a custom tabline.
-- How: The tab_only preset shows tabs, and <leader>t mappings manage them.
-- Why: The tabline helps identify and switch between separate window layouts.

return {
	{
		"nanozuki/tabby.nvim",
		lazy = false,

		opts = {
			preset = "tab_only",
		},

		keys = {
			{
				"<leader>ta",
				"<cmd>$tabnew<cr>",
				desc = "Tab Add",
			},
			{
				"<leader>tc",
				"<cmd>tabclose<cr>",
				desc = "Tab Close",
			},
			{
				"<leader>to",
				"<cmd>tabonly<cr>",
				desc = "Tab Only",
			},
			{
				"<leader>tn",
				"<cmd>tabnext<cr>",
				desc = "Tab Next",
			},
			{
				"<leader>tp",
				"<cmd>tabprevious<cr>",
				desc = "Tab Previous",
			},
			{
				"<leader>tmp",
				"<cmd>-tabmove<cr>",
				desc = "Tab Move Previous",
			},
			{
				"<leader>tmn",
				"<cmd>+tabmove<cr>",
				desc = "Tab Move Next",
			},
			{
				"<leader>tt",
				function()
					if vim.o.showtabline == 0 then
						vim.o.showtabline = 2
					else
						vim.o.showtabline = 0
					end
				end,
				desc = "Toggle Tabline",
			},
		},
	},
}
