-- What: Tree-sitter text objects select code by its structure.
-- How: Use af/if for functions, ac/ic for classes, and as for the surrounding scope.
-- Why: Structural selections make it easier to copy, change, or delete complete code units.

return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	init = function()
		-- Disable built-in filetype plugin mappings to avoid conflicts with these text objects.
		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
		vim.g.no_plugin_maps = true
	end,
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				-- Select the next matching object when the cursor is not already inside one.
				lookahead = true,
				-- Select parameters by character and whole functions by line.
				selection_modes = {
					["@parameter.outer"] = "v",
					["@function.outer"] = "V",
				},
				-- Keep whitespace outside the matched object out of the selection.
				include_surrounding_whitespace = false,
			},
		})

		-- These mappings work in Visual mode and after operators such as d, c, or y.
		vim.keymap.set({ "x", "o" }, "af", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
		end)
		vim.keymap.set({ "x", "o" }, "if", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
		end)
		vim.keymap.set({ "x", "o" }, "ac", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
		end)
		vim.keymap.set({ "x", "o" }, "ic", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
		end)
		-- Scope selection uses the language's locals query rather than its textobjects query.
		vim.keymap.set({ "x", "o" }, "as", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
		end)

		-- TODO: Add swap and move mappings with memorable keys, using vhyroo's mappings as a reference.
	end,
}
