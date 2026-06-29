vim.lsp.config["lua-language-server"] = {
	cmd = { "lua-language-server" },
	root_markers = { ".luarc.json" },
	filetypes = { "lua" },
}

vim.lsp.enable({ 'lua-language-server' })

vim.lsp.config.clangd = {
	cmd = { 'clangd', "--fallback-style=Google", "--background-index", "--clang-tidy" },
	root_markers = { 'compile_commands.json', 'compile_flags.txt' },
	filetypes = { 'c', 'cpp' },
}

vim.lsp.enable({ 'clangd' })

vim.lsp.config.rust_analyzer = {
	cmd = { 'rust-analyzer' },
	root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
	filetypes = { 'rust' },
	settings = {
		['rust-analyzer'] = {
			cargo = {
				allFeatures = true,
			},
			imports = {
				group = {
					enable = true,
				},
			},
			completion = {
				postfix = {
					enable = false,
				},
			},
			check = {
				command = "clippy",
			},
		},
	},
}

-- vim.lsp.enable('rust_analyzer')

vim.lsp.config.pyright = {
	cmd = { 'pyright-langserver', '--stdio' },
	root_markers = { 'pyproject.toml', 'setup.py', '.git', 'pyrightconfig.json' },
	filetypes = { 'python' },
}
vim.lsp.enable('pyright')

-- bash lsp
vim.lsp.config.bashls = {
	cmd = { 'bash-language-server', 'start' },
	root_markers = { '.git', '.bashrc', '.bash_profile' },
	filetypes = { 'sh', 'bash' },
}
vim.lsp.enable('bashls')

-- tex lsp
vim.lsp.config.texlab = {
	cmd = { 'texlab' },
	filetypes = { 'tex' },
}
vim.lsp.enable('texlab')

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local buf = ev.buf
		require("user.keymaps").map_lsp_keybinds(buf)
	end,
})


vim.o.winborder = 'rounded'
vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
