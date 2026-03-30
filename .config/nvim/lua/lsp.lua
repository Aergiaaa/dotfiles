local enabled = true   -- completion on by default
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = false,
				silent = true
			})
			vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		end

		local timer = nil

		vim.api.nvim_create_autocmd('TextChangedI', {
			buffer = ev.buf,
			callback = function()
				if not enabled then return end
				if timer then
					timer:stop()
					timer:close()
				end
				timer = vim.uv.new_timer()
				timer:start(500, 0, vim.schedule_wrap(function()
					timer = nil
					local line = vim.api.nvim_get_current_line()
					if vim.api.nvim_get_mode().mode == 'i'
							and vim.fn.pumvisible() == 0
							and line:match('%S')
					then
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true),
							'n', false
						)
					end
				end))
			end,
		})

		-- toggle completion on/off
		vim.keymap.set('i', '<C-space>', function()
			enabled = not enabled
			if not enabled then
				-- cancel pending timer and dismiss popup if open
				if timer then
					timer:stop()
					timer:close()
					timer = nil
				end
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes('<C-e>', true, false, true),
					'n', false
				)
				vim.notify('completion off', vim.log.levels.INFO)
			else
				vim.notify('completion on', vim.log.levels.INFO)
				-- immediately try to trigger if line has content
				local line = vim.api.nvim_get_current_line()
				if vim.fn.pumvisible() == 0 and line:match('%S') then
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true),
						'n', false
					)
				end
			end
		end, { buffer = ev.buf })

		-- navigate popup
		vim.keymap.set('i', '<Tab>', function()
			return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
		end, { buffer = ev.buf, expr = true })

		vim.keymap.set('i', '<S-Tab>', function()
			return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
		end, { buffer = ev.buf, expr = true })

		-- accept
		vim.keymap.set('i', '<CR>', function()
			return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
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
