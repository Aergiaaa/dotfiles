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
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
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
require 'mini.pick'.setup()
require 'mini.extra'.setup()

map('n', '<leader>fs', ':Pick grep_live<CR>')
map('n', '<leader>\\', ':Pick buffers<CR>')

-- fzf-lua
local fzf = require 'fzf-lua'
fzf.setup {
	"telescope"
}

local function buf_dir()
	return vim.fn.expand('%:p:h')
end

map('n', '<leader>ff', function() fzf.files({ cwd = buf_dir() }) end)
map('n', '<leader>fo', function() fzf.oldfiles({ cwd = buf_dir() }) end)
map('n', '<leader>fm', function()
	fzf.manpages({
		actions = {
			['default'] = function(s)
				vim.cmd('tab Man ' .. s[1]:match('%((.-)%)') .. ' ' .. s[1]:match('(.-)%('))
			end
		}
	})
end)
map('n', '<leader>fh', ':FzfLua helptags<CR>')
map('n', '<leader>fd', ':FzfLua commands<CR>')
map('n', '<leader>gg', function() fzf.grep({ cwd = buf_dir() }) end)
map('n', '<leader>fp', function()
	fzf.fzf_exec('fd --type d . ' .. vim.fn.expand('~'), {
		prompt = 'Dirs> ',
		actions = {
			['default'] = function(selected)
				if selected and selected[1] then
					oil.open_float(selected[1])
				end
			end
		}
	})
end)

-- treesitter
local nt = require 'nvim-treesitter'
nt.setup {
	install_dir = vim.fn.stdpath('data') .. '/site'
}
nt.update { 'go', 'rust', 'lua', 'c', 'bash', 'asm', 'html' }

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

-- colors
require 'nvim-highlight-colors'.setup()

-- alpha
local alpha = require 'alpha'
local dash = require 'alpha.themes.dashboard'

--   Jump to bookmarks                       SPC f m
--   Open last session                       SPC s l

dash.section.buttons.val = {
	dash.button('f', '󰈞  > Find file', ':FzfLua files<CR>'),
	dash.button('h', '  > Recent files', ':FzfLua oldfiles<CR>'),
	dash.button('w', '󰈬  > Find word', ':Pick grep_live<CR>'),
	dash.button("s", "  > Settings", ':Oil --float ~/.config/nvim<CR>'),
	dash.button('q', '󰅚  > Quit', ':q')
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
