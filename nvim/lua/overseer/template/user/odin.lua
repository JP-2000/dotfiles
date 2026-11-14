local function create_template(root, action, extra_args, tag)
	return {
		name = "Odin: " .. action,
		tags = { tag },
		params = {
			package = {
				type = "string",
				default = ".",
				desc = "Package path relative to the project root",
			},
		},
		builder = function(params)
			local command = { "odin", action, params.package, "-error-pos-style:unix" }
			vim.list_extend(command, extra_args)

			local components = {
				{
					"on_output_quickfix",
					errorformat = "%E%f:%l:%c: Error: %m,%W%f:%l:%c: Warning: %m,%-G%.%#",
					open_on_exit = "failure",
					items_only = true,
				},
			}
			if action == "run" or action == "test" then
				table.insert(components, { "open_output", on_start = "always" })
			end
			table.insert(components, "default")

			return {
				cmd = command,
				cwd = root,
				components = components,
			}
		end,
	}
end

return {
	condition = {
		filetype = "odin",
	},
	generator = function(search)
		local root = require("config.odin").root(search.dir)
		local overseer = require("overseer")

		return {
			create_template(root, "check", {}, overseer.TAG.BUILD),
			create_template(root, "build", { "-debug", "-o:none", "-out:app" }, overseer.TAG.BUILD),
			create_template(root, "run", {}, overseer.TAG.RUN),
			create_template(root, "test", { "-define:ODIN_TEST_FANCY=false" }, overseer.TAG.TEST),
		}
	end,
}
