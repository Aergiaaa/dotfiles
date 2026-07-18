ls = require "luasnip"
s = ls.snippet
t = ls.text_node
i = ls.insert_node
c = ls.choice_node
f = ls.function_node
d = ls.dynamic_node
sn = ls.snippet_node
fmt = require "luasnip.extras.fmt".fmt
rep = require "luasnip.extras".rep

function get_go_structs()
	local choices = {}
	local ok, parser = pcall(vim.treesitter.get_parser, 0, 'go')
	if not ok then return { t('Struct') } end

	local tree = parser:parse()[1]
	local root = tree:root()

	local query = vim.treesitter.query.parse('go', [[
		(type_declaration
			(type_spec
				name: (type_identifier) @name
				type: (struct_type)))
	]])

	local seen = {}
	for _, node in query:iter_captures(root, 0) do
		local name = vim.treesitter.get_node_text(node, 0)
		if not seen[name] then
			seen[name] = true
			table.insert(choices, t(name))
		end
	end

	if #choices == 0 then
		table.insert(choices, t('Struct'))
	end

	return choices
end
