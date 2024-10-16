vim.g.FormatOnSave = true

return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		vim.api.nvim_create_user_command("FormatOnSave", function()
			vim.g.FormatOnSave = not vim.g.FormatOnSave
			if vim.g.FormatOnSave == true then
				print("FormatOnSave toggled on")
			else
				print("FormatOnSave toggled off")
			end
		end, {})

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				require("none-ls.diagnostics.eslint_d"),
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.clang_format,
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
							-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
							if vim.g.FormatOnSave then
								vim.lsp.buf.format({ async = false })
							end
						end,
					})
				end
			end,
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
