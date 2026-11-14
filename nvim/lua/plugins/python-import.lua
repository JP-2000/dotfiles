-- What: python-import.nvim finds and inserts Python import statements.
-- How: The mappings in lua/keymaps/lsp.lua request an import for a word or selection.
-- Why: Imports can be added while working at the place where a name is used.

return {
	"kiyoon/python-import.nvim",
	commit = "89c14c399b4f965d9b5d2755aaed6222e0089f20",
	ft = "python",
	-- Install the companion command-line tool used to find imports in the project.
	build = "uv tool install . --force --reinstall",
	opts = {
		custom_function = function(_, word, node)
			if word ~= "pprint" then
				return nil
			end

			-- The upstream lookup prefers the module even for pprint(...).
			-- Import the module for attribute access, but import the function for a direct call.
			if node and node:parent() and node:parent():type() == "attribute" then
				return { "import pprint" }
			end
			return { "from pprint import pprint" }
		end,
	},
}
