-- What: neotest runs tests and displays their results inside Neovim.
-- How: The Python adapter supports running the nearest test, running a file, or debugging a test.
-- Why: Test failures can be inspected close to the code without switching to a separate terminal.

return {
	{
		"nvim-neotest/neotest",

		dependencies = {
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},

		config = function()
			local neotest = require("neotest")

			neotest.setup({
				adapters = {
					require("neotest-python")({
						dap = {
							-- Allow stepping into library code when debugging a failing test.
							justMyCode = false,
						},
					}),
				},
			})

			vim.keymap.set("n", "<leader>tr", function()
				neotest.run.run()
			end, {
				desc = "Test: Run Nearest",
			})

			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, {
				desc = "Test: Run File",
			})

			vim.keymap.set("n", "<leader>td", function()
				neotest.run.run({ strategy = "dap" })
			end, {
				desc = "Test: Debug Nearest",
			})

			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, {
				desc = "Test: Toggle Summary",
			})

			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open({ enter = true })
			end, {
				desc = "Test: Show Output",
			})
		end,
	},
}
