vim.g.mapleader = " "

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")

vim.api.nvim_set_keymap("t", "<Leader><ESC>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("n", "<Leader>t", ":ToggleTerm<CR>")
vim.keymap.set("n", "<A-Tab>", ":e#<CR>")
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {})
vim.api.nvim_set_option("clipboard", "unnamedplus")

local toggle_surrounding_quote_style = function()
	local current_line = vim.fn.getline(".")
	local cursor_pos = vim.fn.col(".") -- 1-based index
	local quote_pairs = { ['"'] = "'", ["'"] = "`", ["`"] = '"' } -- Toggle order

	-- Find the first quote to the left of the cursor
	local left_quote_pos = nil
	for i = cursor_pos - 1, 1, -1 do
		local char = current_line:sub(i, i)
		if quote_pairs[char] then
			left_quote_pos = i
			break
		end
	end

	-- Find the first quote to the right of the cursor
	local right_quote_pos = nil
	for i = cursor_pos, #current_line do
		local char = current_line:sub(i, i)
		if quote_pairs[char] then
			right_quote_pos = i
			break
		end
	end

	-- Ensure both quotes are found and match
	if not left_quote_pos or not right_quote_pos then
		print("Could not find surrounding quotes!")
		return
	end
	if current_line:sub(left_quote_pos, left_quote_pos) ~= current_line:sub(right_quote_pos, right_quote_pos) then
		print("Quotes do not match!")
		return
	end

	-- Replace the quotes
	local current_quote = current_line:sub(left_quote_pos, left_quote_pos)
	local next_quote = quote_pairs[current_quote]
	local updated_line = current_line:sub(1, left_quote_pos - 1)
		.. next_quote
		.. current_line:sub(left_quote_pos + 1, right_quote_pos - 1)
		.. next_quote
		.. current_line:sub(right_quote_pos + 1)

	vim.fn.setline(".", updated_line)
	print("Toggled " .. current_quote .. " to " .. next_quote)
end

vim.keymap.set("n", "<Leader>l", toggle_surrounding_quote_style)
