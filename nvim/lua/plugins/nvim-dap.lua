-- What: nvim-dap connects Neovim to debuggers for Python and Odin.
-- How: Use F5 to start or continue, the step keys below to navigate, and <leader>b for breakpoints.
-- Why: Breakpoints and stepping let you inspect a running program alongside its source.

return {
	{
		"mfussenegger/nvim-dap",

		dependencies = {
			"mfussenegger/nvim-dap-python",
			"stevearc/overseer.nvim",
		},

		config = function()
			local dap = require("dap")

			-- nvim-dap-python configures Python launches through the debugpy-adapter executable.
			require("dap-python").setup("debugpy-adapter")

			-- Odin debugging uses the external lldb-dap executable.
			dap.adapters.lldb = {
				type = "executable",
				command = "lldb-dap",
			}
			dap.configurations.odin = {
				setmetatable({ name = "Odin: build and debug" }, {
					-- Resolve paths and save before the pre-launch build runs.
					__call = function()
						vim.cmd.update()
						local root = require("config.odin").root()
						return {
							name = "Odin: build and debug",
							type = "lldb",
							request = "launch",
							program = vim.fs.joinpath(root, "app"),
							cwd = root,
							args = {},
							stopOnEntry = false,
							preLaunchTask = "Odin: build",
						}
					end,
				}),
			}
			-- Enable task integration after DAP is ready so preLaunchTask builds the Odin executable.
			require("overseer").enable_dap()

			-- Use function keys for execution control and leader mappings for debugger tools.
			vim.keymap.set("n", "<F5>", dap.continue, {
				desc = "Debug: Start / Continue",
			})

			vim.keymap.set("n", "<F10>", dap.step_over, {
				desc = "Debug: Step Over",
			})

			vim.keymap.set("n", "<F11>", dap.step_into, {
				desc = "Debug: Step Into",
			})

			vim.keymap.set("n", "<F12>", dap.step_out, {
				desc = "Debug: Step Out",
			})

			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {
				desc = "Debug: Toggle Breakpoint",
			})

			vim.keymap.set("n", "<leader>B", function()
				local condition = vim.fn.input("Breakpoint condition: ")
				dap.set_breakpoint(condition)
			end, {
				desc = "Debug: Conditional Breakpoint",
			})

			vim.keymap.set("n", "<leader>dr", dap.repl.open, {
				desc = "Debug: Open REPL",
			})

			vim.keymap.set("n", "<leader>dl", dap.run_last, {
				desc = "Debug: Run Last",
			})
		end,
	},
}
