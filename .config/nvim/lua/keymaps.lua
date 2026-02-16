local map = vim.keymap.set

-- user defined keymap
map('v', '<leader>k=', [[:s/\v<(\w*)/\1 = "\1"<CR>]], { desc = 'Convert to key-value pairs' })
map("i", "<C-l>", "{<CR>}<Esc>O", { noremap = true, silent = true })
map("i", "{", "{}<Left>", { noremap = true, silent = true })
map("i", "(", "()<Left>", { noremap = true, silent = true })
map("i", "[", "[]<Left>", { noremap = true, silent = true })
map("i", '"', '""<Left>', { noremap = true, silent = true })
map("i", "'", "''<Left>", { noremap = true, silent = true })

-- lsp keymap
map('i', '<C-i>', vim.lsp.buf.hover)
map({ 'n', 'i' }, '<C-s>', function() vim.lsp.buf.signature_help() end)
map('n', '<leader>ln', function() vim.lsp.buf.rename() end)
map('n', '<leader>lr', function() vim.lsp.buf.references() end)
map('n', '<leader>lt', function() vim.lsp.buf.type_definition() end)
map('n', '<leader>li', function() vim.lsp.buf.implementation() end)
map('n', '<leader>fa', function()
	if vim.bo.filetype == 'sh' or vim.bo.filetype == 'bash' then
		vim.cmd('normal! ggVGgq')
	else
		vim.lsp.buf.format()
	end
end
)

-- utils keymap
map('n', '<leader>ss', ':source<CR>')
map('n', '<leader>w', ':w<CR>', { silent = true })
map('n', '<leader>q', ':q<CR>', { silent = true })
map('n', '<leader><Tab>', ':e #<CR>')
map({ 'n', 'i' }, '<C-w>', ':bd<CR>')
map({ 'n', 'v', 'x' }, '<leader>[', function() vim.cmd.norm('[%') end)
map({ 'n', 'v', 'x' }, '<leader>]', function() vim.cmd.norm(']%') end)
map("i", "<C-H>", "<C-W>", { silent = true, desc = "Delete previous word in insert mode" })
map({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
map({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
map('i', '<C-p>', '<Esc>', { noremap = true })
map('n', '<C-p>', 'i', { noremap = true })
