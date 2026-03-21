vim.pack.add({
	{ src = "https://github.com/AlphaTechnolog/pywal.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/echasnovski/mini.extra" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/goolord/alpha-nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/mbbill/undotree" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{
		src = "https://github.com/ThePrimeagen/harpoon",
		branch = "harpoon2",
	},

})

local map = vim.keymap.set

-- harpoon
local harp = require 'harpoon'
harp:setup {}
map('n', '<leader>a', function() harp:list():add() end)
map('n', '<leader>r', function() harp.ui:toggle_quick_menu(harp:list()) end)

map('n', '<leader>1', function() harp:list():select(1) end)
map('n', '<leader>2', function() harp:list():select(2) end)
map('n', '<leader>3', function() harp:list():select(3) end)
map('n', '<leader>4', function() harp:list():select(4) end)
map('n', '<leader>5', function() harp:list():select(5) end)

map('n', '<leader>,', function() harp:list():prev() end)
map('n', '<leader>.', function() harp:list():next() end)

-- oil
local oil = require 'oil'
oil.setup({
	view_options = {
		show_hidden = true,
	},
	float = {
		padding = 5,
		max_width = 0.5
	}
})

map('n', '<leader>e', ':Oil --float<CR>', { silent = true })

-- mini
local pick = require 'mini.pick'
pick.setup()
require 'mini.extra'.setup()

map('n', '<leader>fs', ':Pick grep_live<CR>')
map('n', '<leader>\\', ':Pick buffers<CR>')

-- fzf-lua
local fzf = require 'fzf-lua'
fzf.setup()
map('n', '<leader>ff', ':FzfLua files<CR>')
map('n', '<leader>fo', ':FzfLua oldfiles<CR>')
map('n', '<leader>fh', ':FzfLua helptags<CR>')
map('n', '<leader>fc', ':FzfLua commands<CR>')


-- treesitter
local nt = require 'nvim-treesitter'
nt.setup {
	install_dir = vim.fn.stdpath('data') .. '/site'
}
nt.update { 'go', 'rust', 'lua', 'c', 'bash', 'asm' }

-- lualine
require 'lualine'.setup {
	options = {
		theme = 'pywal-nvim',
	}
}

-- undotree
map('n', '<leader>;', vim.cmd.UndotreeToggle)

-- pywal
require 'pywal'.setup()

-- mason
require 'mason'.setup()

-- alpha
local alpha = require 'alpha'
local dash = require 'alpha.themes.dashboard'

--   Frecency/MRU                            SPC f r
--
--   Jump to bookmarks                       SPC f m
--
--   Open last session                       SPC s l

dash.section.buttons.val = {
	dash.button('f', '󰈞  > Find file', ':FzfLua files<CR>'),
	dash.button('h', '  > Recent files', ':FzfLua oldfiles<CR>'),
	dash.button('w', '󰈬  > Find word', ':Pick grep_live<CR>'),
	dash.button("s", "  > Settings", ":Oil ~/.config/nvim/init.lua<CR>"),
	dash.button('q', '󰅚  > Quit', ':qa<CR>'),


}

dash.section.header.val = {
	"	░██ ░██           ░██           ░██    ░██                                                    ",
	"░██               ░██           ░██    ░██                                                    ",
	"░██ ░██ ░████████ ░████████  ░████████ ░████████   ░███████  ░██    ░██  ░███████   ░███████  ",
	"░██ ░██░██    ░██ ░██    ░██    ░██    ░██    ░██ ░██    ░██ ░██    ░██ ░██        ░██    ░██ ",
	"░██ ░██░██    ░██ ░██    ░██    ░██    ░██    ░██ ░██    ░██ ░██    ░██  ░███████  ░█████████ ",
	"░██ ░██░██   ░███ ░██    ░██    ░██    ░██    ░██ ░██    ░██ ░██   ░███        ░██ ░██        ",
	"░██ ░██ ░█████░██ ░██    ░██     ░████ ░██    ░██  ░███████   ░█████░██  ░███████   ░███████  ",
	"              ░██                                                                             ",
	"        ░███████                                                                              ",

}

alpha.setup(dash.config)
