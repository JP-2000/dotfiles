-- What: nvim-lspconfig supplies the rust-analyzer language server configuration.
-- How: Neovim starts rust-analyzer from Cargo's bin directory and runs Clippy on save.
-- Why: Rust completion and diagnostics use the project's toolchain and include Clippy checks.

return {
	"neovim/nvim-lspconfig",

	config = function()
		-- Rust tools come from the Cargo installation rather than Mason.
		local cargo_home = vim.env.CARGO_HOME or vim.fn.expand("~/.cargo")
		local cargo_bin = vim.fs.joinpath(cargo_home, "bin")
		local rust_analyzer = vim.fs.joinpath(cargo_bin, "rust-analyzer")

		vim.lsp.config("rust_analyzer", {
			cmd = function(dispatchers, config)
				-- Select the project's toolchain even when Neovim starts elsewhere.
				return vim.lsp.rpc.start({ rust_analyzer }, dispatchers, {
					cwd = config.root_dir,
					env = {
						PATH = cargo_bin .. ":" .. vim.env.PATH,
					},
				})
			end,
			settings = {
				["rust-analyzer"] = {
					checkOnSave = true,
					check = {
						command = "clippy",
					},
				},
			},
		})

		vim.lsp.enable("rust_analyzer")
	end,
}
