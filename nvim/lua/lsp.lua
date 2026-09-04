---@diagnostic disable: need-check-nil

local enabled = true -- completion on by default
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		local force = client and (client.name == 'templ' or client.name == 'tailwindcss' or client.name == 'emmet_ls')

		if client and (force or client:supports_method('textDocument/completion')) then
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
			if vim.fn.pumvisible() == 1 then
				return '<C-y><Cmd>nohl<CR>'
			end
			return '<CR>'
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
	root_markers = { 'go.sum', 'go.mod', '.git' },
})

-- TEMPL
vim.lsp.config('templ', {
	cmd = { 'templ', 'lsp' },
	filetypes = { 'templ' },
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
	filetypes = { 'html', 'css', 'templ' },
	root_markers = { '.git', 'package.json' }
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "css" },
	callback = function()
		vim.bo.formatprg = "prettier --stdin-filepath %"
	end
})

-- TAILWIND
vim.lsp.config('tailwindcss', {
	cmd = { 'tailwindcss-language-server', '--stdio' },
	filetypes = { 'html', 'css', 'templ', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
	root_markers = { 'tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'package.json', '.git' },
	settings = {
		tailwindCSS = {
			includeLanguages = {
				templ = 'html', -- treat templ as html for class completions
			},
		},
	},
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

-- PY

vim.lsp.config('ruff', {
	cmd = { 'ruff', 'server' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
	settings = {},
})

vim.lsp.config('pyright', {
	cmd = { 'pyright-langserver', '--stdio' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
	settings = {
		python = {
			venvPath = '.',
			venv = '.venv',
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = 'openFilesOnly',
			}
		}
	}
})

-- NIX
vim.lsp.config('nil_ls', {
	cmd = { 'nil' },
	filetypes = { 'nix' },
	root_markers = { 'flake.nix', 'flake.lock', '.git' },
	settings = {
		['nil'] = {
			formatting = { commands = { 'nixfmt'} },
		},
	},
})

-- LAZY LOAD — enable each LSP only when its filetype is opened
local servers = {
	'lua_ls',
	'gopls',
	'rust_analyzer',
	'clangd',
	'bashls',
	'emmet_ls',
	'ts_ls',
	'templ',
	'ruff',
	'pyright',
	'nil_ls',
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
