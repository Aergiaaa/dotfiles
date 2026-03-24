local map = vim.keymap.set

-- user defined keymap
map('v', '<leader>k=', [[:s/\v<(\w*)/\1 = "\1"<CR>]], { desc = 'Convert to key-value pairs' })
map('v', '<leader>k:', [[:s/\v<(\w*)/\1: "\1"<CR>]], { desc = 'Convert to key-value pairs' })
map("i", "<C-l>", "{<CR>}<Esc>O", { noremap = true, silent = true })
map('i', '{', '{}<Left>', { noremap = true, silent = true })
map('i', '(', '()<Left>', { noremap = true, silent = true })
map('i', '[', '[]<Left>', { noremap = true, silent = true })
map("i", '"', '""<Left>', { noremap = true, silent = true })
map("i", "'", "''<Left>", { noremap = true, silent = true })

-- window navigation
map('n', '<leader><Left>', ':wincmd h<CR>')
map('n', '<leader><Down>', ':wincmd j<CR>')
map('n', '<leader><Up>', ':wincmd k<CR>')
map('n', '<leader><Right>', ':wincmd l<CR>')
map('n', '<leader>,', function()
	vim.cmd('vert res +' .. vim.v.count1)
end)
map('n', '<leader><', function()
	vim.cmd('vert res -' .. vim.v.count1)
end)
map('n', '<leader>.', function()
	vim.cmd('res +' .. vim.v.count1)
end)
map('n', '<leader>>', function()
	vim.cmd('res -' .. vim.v.count1)
end)

-- lsp keymap
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
map('n', '<leader>!', ':q!<CR>', { silent = true })
map('n', '<leader><Tab>', ':e #<CR>')
map("i", "<C-H>", "<C-W>", { silent = true, desc = "Delete previous word in insert mode" })
map({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
map({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
map('i', '<C-p>', '<Esc>', { noremap = true })
map('n', '<C-p>', 'i', { noremap = true })


-- terminal mode
map('n', '<leader><CR>', ':term<CR>', { desc = "open terminal" })
map('t', '<C-p>', '<C-\\><C-n>', { desc = "switch terminal mode" })
map('n', '<leader>q', ':bd<CR>', { desc = "clear buffer" })
map('n', '<leader>Q', ':bd!<CR>', { desc = "clear buffer" })

-- select full block
map('n', '<C-b>', 'v{jo}k')

-- wrapper
vim.keymap.set('v', '<leader>]', function()
	-- exit visual first so '< '> marks are set correctly
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)

	local char = vim.fn.getcharstr()

	local pairs = {
		['('] = { '(', ')' },
		[')'] = { '(', ')' },
		['['] = { '[', ']' },
		[']'] = { '[', ']' },
		['{'] = { '{', '}' },
		['}'] = { '{', '}' },
		['"'] = { '"', '"' },
		["'"] = { "'", "'" },
		['`'] = { '`', '`' },
		['<'] = { '<', '>' },
	}

	local wrap = pairs[char] or { char, char }

	local pos1 = vim.fn.getpos("'<")
	local pos2 = vim.fn.getpos("'>")
	local ls, cs = pos1[2], pos1[3]
	local le, ce = pos2[2], pos2[3]

	local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
	local last_line = lines[#lines]
	ce = math.min(ce, #last_line)

	if ls == le then
		local line = lines[1]
		lines[1] = line:sub(1, cs - 1) .. wrap[1] .. line:sub(cs, ce) .. wrap[2] .. line:sub(ce + 1)
	else
		lines[1] = lines[1]:sub(1, cs - 1) .. wrap[1] .. lines[1]:sub(cs)
		lines[#lines] = last_line:sub(1, ce) .. wrap[2] .. last_line:sub(ce + 1)
	end

	vim.api.nvim_buf_set_lines(0, ls - 1, le, false, lines)
end)
