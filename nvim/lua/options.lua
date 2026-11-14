-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Window splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Text layout
vim.opt.wrap = false
vim.opt.breakindent = true

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Scrolling
vim.opt.scrolloff = 999

-- Visual block editing
vim.opt.virtualedit = "block"

-- Search and preview
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- UI
vim.opt.termguicolors = true
vim.opt.cmdheight = 0
vim.opt.showtabline = 0

-- Responsiveness
-- Make CursorHold-based UI, including diagnostic floats, feel more responsive.
vim.opt.updatetime = 250

-- Diagnostics
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})
