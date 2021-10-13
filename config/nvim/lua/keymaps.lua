vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local options = { noremap = true, silent = true }
local normal_mode_maps = {
    -- toggles
    { key = '<F2>', map = [[<cmd>set number! relativenumber!<cr>]] },

    -- navigation
    { key = '<leader><leader>', map = [[<c-^>]] },
    { key = '<leader>n', map = [[<cmd>bnext<cr>]] },
    { key = '<leader>p', map = [[<cmd>bprev<cr>]] },
    { key = '<leader>q', map = [[<cmd>bw<cr>]] },

    -- fzf
    { key = '<leader>;', map = [[<cmd>Buffers<cr>]] },
    { key = '<leader>ff', map = [[<cmd>Files<cr>]] },
    { key = '<leader>fb', map = [[<cmd>Marks<cr>]] },
    { key = '<leader>fh', map = [[<cmd>History<cr>]] },
    { key = '<leader>fa', map = [[<cmd>History<cr>]] },
    
    { key = '<leader>tc', map = [[<cmd>Colors<cr>]] },
    { key = '<leader>g', map = [[<cmd>Rg<cr>]] },

    -- Session
    { key = '<leader>ss', map = [[<cmd>SessionSave<cr>]] },
    { key = '<leader>sl', map = [[<cmd>SessionLoad<cr>]] },

    -- lsp
    { key = 'K', map = [[<cmd>lua vim.lsp.buf.hover()<cr>]] },
    { key = '<C-k>', map = [[<cmd>lua vim.lsp.buf.definition()<cr>]] },
    { key = 'gi', map = [[<cmd>lua vim.lsp.buf.implementation()<cr>]] },
    { key = '<leader>o', map = [[<cmd>LspTroubleToggle<cr>]] },
    -- { key = '<leader>a', map = [[<cmd>lua vim.lsp.buf.document_highlight()<cr>]] },
    -- { key = '<leader>c', map = [[<cmd>lua vim.lsp.buf.clear_references()<cr>]] },
    { key = '<leader>"', map = [["+]] },
    { key = 'F', map = [[<cmd>lua vim.lsp.buf.formatting()<cr>]] },
    { key = 'T', map = [[<cmd>lua require'lsp_extensions'.inlay_hints()<cr>]] },

    -- Other
    { key = '<leader>m', map = [[<cmd>silent !mpcfzf<cr>]] },
}


local insert_mode_maps = {
    { key = '<C-j>', map = '<ESC>' },
}


for idx = 1, #normal_mode_maps do
    if normal_mode_maps[idx].options then
        local options = normal_mode_maps[idx].options
        vim.api.nvim_set_keymap('n', normal_mode_maps[idx].key, normal_mode_maps[idx].map ,options)
    else
        vim.api.nvim_set_keymap('n', normal_mode_maps[idx].key, normal_mode_maps[idx].map ,options)
    end
end

for idx = 1, #insert_mode_maps do
    if insert_mode_maps[idx].options then
        local options = insert_mode_maps[idx].options
        vim.api.nvim_set_keymap('i', insert_mode_maps[idx].key, insert_mode_maps[idx].map ,options)
    else
        vim.api.nvim_set_keymap('i', insert_mode_maps[idx].key, insert_mode_maps[idx].map ,options)
    end
end




-- local ff = {
-- 	{ 'this', 'and this' },
-- 	{ 'that', 'and that' },
-- }
-- print(ff[1][2])
