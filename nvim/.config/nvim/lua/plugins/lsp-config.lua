return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"folke/neodev.nvim",
			{ "j-hui/fidget.nvim", tag = "legacy" },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local neodev = require("neodev")

			-- Load custom keymaps
			require("user.keymaps").map_lsp_keybinds()

			neodev.setup()

			-- Setup mason
			mason.setup({ ui = { border = "rounded" } })

			-- Custom diagnostic handler to filter specific error codes
			for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
				local default_diagnostic_handler = vim.lsp.handlers[method]
				vim.lsp.handlers[method] = function(err, result, context, config)
					if err ~= nil and (err.code == -32802 or err.code == -32603) then
						return
					end
					return default_diagnostic_handler(err, result, context, config)
				end
			end

			-- LSP server configurations
			local servers = {
				bashls = {},
				clangd = { cmd = { "clangd", "--offset-encoding=utf-16" } },
				html = {},
				sqlls = {},
				texlab = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enabled = false },
						},
					},
				},
				pyright = {},
				matlab_ls = {
					cmd = { "matlab-language-server", "--stdio" },
					settings = {
						installPath = "/usr/local/MATLAB/R2024b",
					},
					filetypes = { "matlab" },
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
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
				},
				dockerls = {},
				docker_compose_language_service = { filetypes = { "yaml.docker-compose" } },
			}

			-- Setup capabilities with nvim-cmp
			local capabilities =
			    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			-- Common on_attach function
			local function on_attach(_, buffer_number)
				require("user.keymaps").map_lsp_keybinds(buffer_number)
				vim.api.nvim_create_user_command("Format", function(args)
					local range = nil
					if args.count ~= -1 then
						local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args
							.line2, true)[1]
						range = {
							start = { args.line1, 0 },
							["end"] = { args.line2, end_line:len() },
						}
					end
					require("conform").format({ async = true, lsp_format = "fallback", range = range })
				end, { range = true })
			end

			-- Setup LSP servers
			local function setup_servers()
				for name, config in pairs(servers) do
					lspconfig[name].setup({
						autostart = config.autostart,
						cmd = config.cmd,
						capabilities = capabilities,
						filetypes = config.filetypes,
						init_options = config.init_options,
						on_attach = on_attach,
						settings = config.settings,
						root_dir = config.root_dir,
					})
				end
			end

			setup_servers()

			-- Diagnostic UI configuration
			vim.diagnostic.config({ float = { border = "rounded" } })

			-- Set default border for LSP windows
			require("lspconfig.ui.windows").default_options.border = "rounded"
		end,
	},
}
