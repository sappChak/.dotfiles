return {
	'mrcjkb/rustaceanvim',
	version = '^9',
	lazy = false,
	config = function()
		vim.g.rustaceanvim = {
			-- LSP configuration
			server = {
				default_settings = {
					['rust-analyzer'] = {
						files = {
							excludeDirs = { "~/projects/lametesuncrey/lametesuncrey-ebpf/src/bindings" },
						},
					},
				},
			},

		}
	end


}
