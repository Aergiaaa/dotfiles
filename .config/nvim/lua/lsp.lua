local enabled = true -- completion on by default
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

-- RUST
vim.lsp.config('rust_analyzer', {
	cmd = { 'rust-analyzer' },
	filetypes = { 'rust' },
	root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
	settings = {
		['rust-analyzer'] = {
			cargo = {
				allFeatures = true
			},
			procMacro = {
				enable = true
			},
		}
	}
})

-- HTML/CSS
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config('emmet_ls', {
	cmd = { 'emmet-language-server', '--stdio' },
	capabilities = capabilities,
	filetypes = { 'html', 'css' },
	root_markers = { '.git', 'package.json' }
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "css" },
	callback = function()
		vim.bo.formatprg = "prettier --stdin-filepath %"
	end
})


-- JS/TS
vim.lsp.config('ts_ls', {
	cmd = { 'typescript-language-server', '--stdio' },
	filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
	root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
	init_options = {
		hostInfo = 'neovim',
	},
	settings = {
		typescript = {
			inlayHints = { includeInlayParameterNameHints = 'all' }
		}
	}
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
	html            = 'emmet_ls',
	css             = 'emmet_ls',
	javascript      = 'ts_ls',
	javascriptreact = 'ts_ls',
	typescriptreact = 'ts_ls',
	vue             = 'ts_ls',
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
