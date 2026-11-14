-- What: SimpylFold supplies folding rules for Python code.
-- How: It loads for Python files; use Neovim's fold commands such as zc and zo.
-- Why: Folding hides sections temporarily, while high initial fold levels keep code visible on opening.

return {
	"tmhedberg/SimpylFold",
	ft = "python",

	init = function()
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,
}
