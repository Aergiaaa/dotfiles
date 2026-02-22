-- for completion
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

-- LUA
vim.lsp.config('lua_ls', {
	cmd = { 'lua-language-server' },
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})

-- BASH
vim.lsp.config('bashls', {
	cmd = { 'bash-language-server', 'start' },
	filetype = { 'sh', 'bash' }
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
	root_markers = { 'go.', 'go.mod', '.git' }
})


-- EXEC
vim.lsp.enable({ 'lua_ls', "gopls", "rust_analyzer", "clangd", "bashls" })
