-- What: nvim-dap-ui shows debugger panels for variables, stack frames, and breakpoints.
-- How: Panels open when debugging starts and close when it ends; <leader>du toggles them.
-- Why: Debugger state stays visible without having to inspect everything through the REPL.

return {
	{
		"rcarriga/nvim-dap-ui",

		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end

			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.keymap.set("n", "<leader>du", dapui.toggle, {
				desc = "Debug: Toggle UI",
			})
		end,
	},
}
