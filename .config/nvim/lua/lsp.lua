-- for completion
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false, silent = true })
			vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		end

		-- toggle for completion
		vim.keymap.set('i', '<C-space>', function()
			if vim.fn.pumvisible() == 1 then
				return '<C-e>'
			else
				return '<C-x><C-o>'
			end
		end, { buffer = ev.buf, expr = true })

		-- setting for up/down hover
		vim.keymap.set('i', '<Tab>', function()
			if vim.fn.pumvisible() == 1 then
				return '<C-n>'
			else
				return '<Tab>'
			end
		end, { buffer = ev.buf, expr = true })

		vim.keymap.set('i', '<S-Tab>', function()
			if vim.fn.pumvisible() == 1 then
				return '<C-p>'
			else
				return '<S-Tab>'
			end
		end, { buffer = ev.buf, expr = true })

		-- for accept
		vim.keymap.set('i', '<CR>', function()
			if vim.fn.pumvisible() == 1 then
				return '<C-y>'
			else
				return '<CR>'
			end
		end, { buffer = ev.buf, expr = true })
	end,
})

-- LUA
vim.lsp.config('lua_ls', {
	cmd = { 'lua-language-server' },
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false
			}
		}
	}
})


-- BASH
vim.lsp.config('bashls', {
	cmd = { 'bash-language-server', 'start' },
	filetypes = { 'sh', 'bash' }
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sh", "bash" },
	callback = function()
		vim.bo.formatprg = "shfmt -i 2"
	end
})

-- GOLANG
vim.lsp.config('gopls', {
	cmd = { 'gopls' },
	filetypes = { 'go', 'gomod' },
	root_markers = { 'go.sum', 'go.mod', '.git' }
})

-- ASM
vim.lsp.config('asm-lsp', {
	cmd = { 'asm-lsp' },
	filetypes = { 'asm' }
})

-- EMMET
vim.lsp.config('emmet_ls', {
	cmd = { 'emmet-ls', '--stdio' },
	filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact' },
})

-- EXEC
vim.lsp.enable({ 'lua_ls', "gopls", "rust_analyzer", "clangd", "bashls", "asm-lsp", "emmet_ls" })
