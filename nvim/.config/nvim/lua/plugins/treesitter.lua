return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"c", "cpp", "go", "lua", "python", "rust",
			"tsx", "javascript", "typescript",
			"vimdoc", "vim", "bash",
			"json", "markdown", "markdown_inline", "yaml",
			"c_sharp", "java",
			"xml", "dockerfile", "toml", "latex", "bibtex"})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
