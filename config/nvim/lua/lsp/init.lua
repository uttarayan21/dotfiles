require("lsp.rust-analyzer")
-- Set completeopt to have a better completion experience
vim.o.completeopt= "menuone,noinsert,noselect"

-- " Avoid showing message extra message when using completion
-- vim.o.shortmess += 'c'
vim.o.signcolumn = "yes"
