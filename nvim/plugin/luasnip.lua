local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("c", {
  s("inc", {
    t("#include <"), i(1), t(">")
  }),

  s("main", fmt([[
  int main(int argc, char *argv[], char *env[])
  {{
    {body}
  }}
  ]], { body = i(1) })),

  s("func", fmt([[
  {return_type} {func_name}({func_args})
  {{
    {func_body}
  }}
  ]], {
    return_type = i(1),
    func_name = i(2),
    func_args = i(3),
    func_body = i(4)
  })),

  s("for", fmt([[
  for({init}; {cond}; {stat})
  {{
    {body}
  }}
  ]], {
    init = i(1),
    cond = i(2),
    stat = i(3),
    body = i(4),
  })),

    s("while", fmt([[
  while({cond})
  {{
    {body}
  }}
  ]], {
    cond = i(1),
    body = i(2),
  }))
})
