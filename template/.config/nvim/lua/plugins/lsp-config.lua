return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Global keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", {})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"lua_ls",
				"svelte",
				"bashls",
				"cssls",
				"html",
				"jsonls",
				"rust_analyzer",
				"glsl_analyzer",
			},
			handlers = {
				function(server)
					require("lspconfig")[server].setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						on_attach = function(client, bufnr)
							if client.server_capabilities.inlayHintProvider then
								vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
							end
						end,
					})
				end,

				tsserver = function()
					require("lspconfig").tsserver.setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						on_attach = function(client, bufnr)
							if client.server_capabilities.inlayHintProvider then
								vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
							end
						end,
						init_options = {
							plugins = {
								{
									name = "@vue/typescript-plugin",
									location = vim.fn.stdpath("data")
										.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
									languages = { "vue" },
								},
							},
						},
						filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					})
				end,

				svelte = function()
					require("lspconfig").svelte.setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						on_attach = function(client, bufnr)
							if client.server_capabilities.inlayHintProvider then
								vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
							end
							vim.api.nvim_create_autocmd("BufWritePost", {
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
								end,
							})
						end,
						handlers = {
							["textDocument/definition"] = function(_, result)
								if result then
									local seen = {}
									local unique_targets = {}

									for _, item in ipairs(result) do
										local key = item.targetUri
											.. "|"
											.. item.targetRange.start.line
											.. "|"
											.. item.targetRange.start.character
										if not seen[key] then
											seen[key] = true
											table.insert(unique_targets, item)
										end
									end

									if #unique_targets == 1 then
										local params = {
											uri = unique_targets[1].targetUri,
											range = unique_targets[1].targetRange,
										}
										vim.lsp.util.jump_to_location(params, "utf-16")
									elseif #unique_targets > 1 then
										local quickfix_items = {}
										for _, item in ipairs(unique_targets) do
											table.insert(quickfix_items, {
												bufnr = vim.uri_to_bufnr(item.targetUri),
												lnum = item.targetRange.start.line + 1,
												col = item.targetRange.start.character + 1,
												text = "Definition",
											})
										end
										vim.fn.setqflist({}, "r", { title = "LSP Definitions", items = quickfix_items })
										vim.cmd("copen")
									else
										print("No valid definitions found.")
									end
								end
							end,
						},
					})
				end,

				jsonls = function()
					require("lspconfig").jsonls.setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						on_attach = function(client, bufnr)
							if client.server_capabilities.inlayHintProvider then
								vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
							end
						end,
						filetypes = { "json", "jsonc" },
						settings = {
							json = {
								schemas = {
									{
										fileMatch = { "package.json" },
										url = "https://json.schemastore.org/package.json",
									},
									{
										fileMatch = { "tsconfig*.json" },
										url = "https://json.schemastore.org/tsconfig.json",
									},
									{
										fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
										url = "https://json.schemastore.org/prettierrc.json",
									},
									{
										fileMatch = { ".eslintrc", ".eslintrc.json" },
										url = "https://json.schemastore.org/eslintrc.json",
									},
									{
										fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
										url = "https://json.schemastore.org/babelrc.json",
									},
									{ fileMatch = { "lerna.json" }, url = "https://json.schemastore.org/lerna.json" },
									{
										fileMatch = { "now.json", "vercel.json" },
										url = "https://json.schemastore.org/now.json",
									},
									{
										fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
										url = "http://json.schemastore.org/stylelintrc.json",
									},
								},
							},
						},
					})
				end,
			},
		},
	},
}
