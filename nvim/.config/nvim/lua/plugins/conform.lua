return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		default_format_opts = {
			async = true,
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			python = { "black" },
			cpp = { "clang-format" },
			c = { "clang-format" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			yaml = { "prettier" },
			tex = { "latexindent" },
		},
		formatters = {
			["clang-format"] = {
				prepend_args = {
					"--fallback-style=Google",
				},
			},
		},
	},
}
