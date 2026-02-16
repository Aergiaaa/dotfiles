local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local fmt = require "luasnip.extras.fmt".fmt

local map = vim.keymap.set

map({ 'i', 's' }, '<M-f>', function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true }
)

map({ 'i', 's' }, '<C-f>', function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true }
)


map({ 'i', 's' }, '<C-b>', function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true }
)


ls.add_snippets("lua", {
	-- use "snip"
	-- ls.add_snippets("<>",{
	-- s("<>",{
	-- t(<>)
	-- 	})
	-- })
	s("snip", fmt(
		[[
		ls.add_snippets("{}", {{
			s("{}", {{
				t({})
			}})
		}})
		]], {
			i(1), i(2), i(3)
		}))
})

ls.add_snippets("go", {
	-- use "for"
	-- for <> := <>; <>; <> {
	-- 	<>
	-- }
	s("for", fmt(
		[[
		for {} := {}; {};{} {{
			{}
		}}
		]], {
			i(1, 'i'), i(2), i(3, 'i<smth'), i(4, 'i++'), i(5)
		})),

	-- use "foreach"
	-- for <>, <> := range <> {
	-- 	<>
	-- }
	s("foreach", fmt(
		[[
		for {} := range {} {{
			{}
		}}
		]], {
			c(1, {
				t(''),
				fmt([[{}, {}]], { i(1), i(2) })
			}), i(2), i(3)
		})),

	-- use "if"
	-- if <<err|''|err <:>= <>> != nil>|'' {
	-- 	<
	--	<>|<
	--	return <>>
	-- 	>
	-- }
	s("if", fmt(
		[[
		if {} {{
			{}
		}}
		]], {
			c(1, {
				t(''),
				fmt(
					[[
				{} != nil
				]], c(1, {
						t('err'),
						fmt(
							[[
							err {}= {}; err
							]], {
								i(1, ':'), i(2)
							}),
						t(''),
					}))
			}), c(2, {
			t(''),
			fmt(
				[[
					{}
					return {}
					]], {
					i(1), i(2)
				})
		})
		})),

	-- use "fun"
	-- func <name>(<>) <> {
	-- 		<>
	--
	-- 		return <>
	-- }
	s("fun", fmt(
		[[
		func {}({}) {}
		]], {
			i(1, 'Name'), i(2), c(3, {
			fmt(
				[[
				{{
					{}
				}}
				]], {
					i(1)
				}),
			fmt(
				[[
				{} {{
					{}
					return {}
				}}
				]], {
					i(1), i(2), i(3)
				})
		})
		})),

	-- use "met"
	-- func (<w *What>) <Name>(<>) <> {
	-- 		<<>|<>
	-- 		return <>>
	-- }
	s({ trig = "(%w+)%.met", regTrig = true, wordTrig = false },
		fmt(
			[[
			func ({}) {}({}) {}
			]], {
				f(
					function(_, snip)
						local class = snip.captures[1]
						local char = class:sub(1, 1):lower()
						return char .. " *" .. class
					end
				),
				i(1, 'Init'), i(2), c(3, {
				fmt(
					[[
				{{
					{}
				}}
				]], {
						i(1)
					}),
				fmt(
					[[
				{} {{
					{}
					return {}
				}}
				]], {
						i(1), i(2), i(3)
					})
			})
			})),

	-- use "type"
	-- type <<> <struct|interface> {
	-- <>
	-- }>
	s("type", fmt(
		[[
		type {}
		]], {
			c(1, {
				t(''),
				fmt(
					[[
					{} {} {{
						{}
					}}
					]], {
						i(1), c(2, {
						t('struct'),
						t('interface')
					}), i(3)
					})
			}),
		})),

	-- use "case"
	-- switch <> {
	-- case <>:
	-- <default:|"">
	-- }
	s("case", fmt(
		[[
		switch {} {{
		case {}:
		{}
		}}
		]], {
			i(1, 'condition'), i(2, 'matches'), c(3, {
			fmt([[
			{}
			default:
			{}
			]], { i(1), i(2) }),
			t('')
		})
		})),

	-- use "iota"
	-- const (
	-- 	_ <> = iota
	-- 	<>
	-- )
	s("iota", fmt(
		[[
		const (
			_ {} = iota
			{}
		)
		]], {
			i(1), i(2)
		}
	)),

	-- use "main"
	-- func main() {
	-- <>
	-- }
	s("main", fmt(
		[[
		func main() {{
			{}
		}}
		]], {
			i(1)
		})),

	s({ trig = "(%w+)%.app", regTrig = true, wordTrig = false },
		{
			f(function(_, snip) return snip.captures[1] end),
			t(" = append("),
			f(function(_, snip) return snip.captures[1] end),
			t(", "),
			i(1),
			t(")")
		})
})
