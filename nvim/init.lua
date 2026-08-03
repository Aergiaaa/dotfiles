require "options"
require "keymaps"
require "plugins"
require "snippet"
require "lsp"

local map = vim.keymap.set

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { buffer = true, silent = true })
		vim.keymap.set("n", "q", ":cclose<CR>", { buffer = true, silent = true })
	end
})
--- Set completeopt
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Just use native <C-n> behavior
map('i', '<C-n>', '<C-n>', { noremap = true })
map('i', '<C-p>', '<C-p>', { noremap = true })
vim.o.autocomplete = false

vim.api.nvim_set_hl(0, 'MiniPickMatchCurrent', { link = 'Visual' })

vim.cmd(":hi statusline guibg=NONE")
