require('Comment').setup()

local comment_ft = require('Comment.ft')
comment_ft.set("nix", {"# %s", "/* %s */"})
