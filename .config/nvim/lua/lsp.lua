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
			runtime = {
				version = 'LuaJIT'
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					'${3d}/luv/library' -- for vim.uv / luv types
				},
				checkThirdParty = false,
				maxPreload = 1000,
				preloadFileSize = 500
			},
			diagnostics = {
				globals = { 'vim' },
				disable = { 'missing-fields' }
			},
			telemetry = {
				enable = false,
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

-- LAZY LOAD — enable each LSP only when its filetype is opened
local ft_servers = {
	lua             = 'lua_ls',
	go              = 'gopls',
	gomod           = 'gopls',
	rust            = 'rust_analyzer',
	c               = 'clangd',
	cpp             = 'clangd',
	sh              = 'bashls',
	bash            = 'bashls',
	asm             = 'asm-lsp',
	s               = 'asm-lsp',
	html            = 'emmet_ls',
	css             = 'emmet_ls',
	javascriptreact = 'emmet_ls',
	typescriptreact = 'emmet_ls',
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = vim.tbl_keys(ft_servers),
	callback = function(ev)
		local server = ft_servers[ev.match]
		if server then
			vim.lsp.enable(server)
		end
	end,
})
