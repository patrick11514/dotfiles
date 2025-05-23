return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		--config = function()
		--    require("mason-lspconfig").setup({
		--        ensure_installed = { "lua_ls", "clangd", "svelte", "vuels", "ts_ls", "bashls", "cssls", "cmake", "html" },
		--    })
		--end,
		lazy = false,
		opts = {
			auto_install = true,
			handlers = {},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hint = { enabled = true },
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			local mason_path = vim.fn.stdpath("data") .. "/mason"
			local vue_ls_path = mason_path .. "/packages/vue-language-server"
			local vuels = vue_ls_path .. "/node_modules/@vue/language-server"

			local function on_attach(client, bufnr)
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vuels,
							languages = { "vue" },
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.svelte.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
						end,
					})
				end,
				handlers = {
					["textDocument/definition"] = function(_, result, ctx, _)
						-- If results are available
						if result then
							local seen = {}
							local unique_targets = {}

							-- Collect unique targets (comparing the targetUri and targetRange)
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

							-- If there is only one unique target, jump directly to it
							if #unique_targets == 1 then
								local params =
									{ uri = unique_targets[1].targetUri, range = unique_targets[1].targetRange }
								vim.lsp.util.jump_to_location(params, "utf-16")
							elseif #unique_targets > 1 then
								-- If multiple unique targets, populate the quickfix list
								local quickfix_items = {}
								for _, item in ipairs(unique_targets) do
									table.insert(quickfix_items, {
										bufnr = vim.uri_to_bufnr(item.targetUri),
										lnum = item.targetRange.start.line + 1, -- Neovim is 1-indexed
										col = item.targetRange.start.character + 1, -- Neovim is 1-indexed
										text = "Definition",
									})
								end

								-- Set the quickfix list with the locations
								vim.fn.setqflist({}, "r", { title = "LSP Definitions", items = quickfix_items })

								-- Open the quickfix list
								vim.cmd("copen")
							else
								print("No valid definitions found.")
							end
						end
					end,
				},
			})

			lspconfig.volar.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.glsl_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
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
								fileMatch = {
									".prettierrc",
									".prettierrc.json",
									"prettier.config.json",
								},
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
							{
								fileMatch = { "lerna.json" },
								url = "https://json.schemastore.org/lerna.json",
							},
							{
								fileMatch = { "now.json", "vercel.json" },
								url = "https://json.schemastore.org/now.json",
							},
							{
								fileMatch = {
									".stylelintrc",
									".stylelintrc.json",
									"stylelint.config.json",
								},
								url = "http://json.schemastore.org/stylelintrc.json",
							},
						},
					},
				},
				on_attach = on_attach,
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", {})
		end,
	},
}
