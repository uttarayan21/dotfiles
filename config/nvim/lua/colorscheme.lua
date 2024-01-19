local vim = vim
vim.o.termguicolors = true
vim.cmd.colorscheme "sonokai"
-- vim.cmd [[colorscheme sonokai]]
-- require("catppuccin").setup({
--     -- flavour = "mocha",
--     background = { -- :h background
--         light = "latte",
--         dark = "mocha",
--     },
-- })
local colors = {
    black       = '#181819',
    bg0         = '#2c2e34',
    bg1         = '#30323a',
    bg2         = '#363944',
    bg3         = '#3b3e48',
    bg4         = '#414550',
    bg_red      = '#ff6077',
    diff_red    = '#55393d',
    bg_green    = '#a7df78',
    diff_green  = '#394634',
    bg_blue     = '#85d3f2',
    diff_blue   = '#354157',
    diff_yellow = '#4e432f',
    fg          = '#e2e2e3',
    red         = '#fc5d7c',
    orange      = '#f39660',
    yellow      = '#e7c664',
    green       = '#9ed072',
    blue        = '#76cce0',
    purple      = '#b39df3',
    grey        = '#7f8490',
    none        = 'NONE',
}

-- vim.cmd.colorscheme "catppuccin"
-- Override some colors
vim.cmd('hi Normal guibg=' .. colors.black)
vim.cmd('hi NormalNC guibg=' .. colors.black)
vim.cmd('hi EndOfBuffer guibg=' .. colors.black)
-- vim.cmd('hi ToggleTerm1Buffer guibg='..colors.black)
vim.cmd('hi NonText guibg=' .. colors.black)
vim.cmd('hi link LspInlayHint Comment')
vim.cmd('hi LspInlayHint guibg=nil')
