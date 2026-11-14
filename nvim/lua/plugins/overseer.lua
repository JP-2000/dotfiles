-- What: overseer.nvim runs tasks and keeps their output available in a task list.
-- How: The <leader>o mappings run Odin checks, builds, programs, and tests through config.odin.
-- Why: The same task system supports both manual commands and the debugger's pre-launch build.

return {
	"stevearc/overseer.nvim",
	version = "v2.1.0",
	cmd = { "OverseerRun", "OverseerToggle", "OverseerTaskAction" },

	opts = {
		-- DAP enables the integration after its dependencies have loaded.
		dap = false,
	},

	keys = {
		-- The Odin helper saves the current file and finds the project root before starting a task.
		{
			"<leader>oc",
			function()
				require("config.odin").run("Odin: check")
			end,
			ft = "odin",
			desc = "Odin: Check",
		},
		{
			"<leader>ob",
			function()
				require("config.odin").run("Odin: build")
			end,
			ft = "odin",
			desc = "Odin: Build for debugging",
		},
		{
			"<leader>or",
			function()
				require("config.odin").run("Odin: run")
			end,
			ft = "odin",
			desc = "Odin: Run",
		},
		{
			"<leader>ot",
			function()
				require("config.odin").run("Odin: test")
			end,
			ft = "odin",
			desc = "Odin: Test",
		},
		{
			"<leader>oo",
			"<cmd>OverseerToggle<cr>",
			ft = "odin",
			desc = "Odin: Toggle tasks",
		},
	},
}
