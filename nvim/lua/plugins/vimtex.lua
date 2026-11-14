-- What: VimTeX provides LaTeX editing, compilation, and PDF viewer integration.
-- How: Its filetype support activates for LaTeX files, and :VimtexView opens Zathura.
-- Why: Editing the source and viewing the compiled document fit into the same workflow.

return {
	"lervag/vimtex",

	-- VimTeX should not be lazy-loaded.
	-- The plugin already loads itself only for LaTeX files.
	lazy = false,

	init = function()
		-- The external zathura program must be installed to view PDFs.
		vim.g.vimtex_view_method = "zathura"
	end,
}
