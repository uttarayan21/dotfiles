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
    { key = '<leader>f', map = [[<cmd>Files<cr>]] },
    { key = '<leader>g', map = [[<cmd>Rg<cr>]] },

    -- lsp
    { key = 'K', map = [[<cmd>lua vim.lsp.buf.hover()<cr>]] },
    { key = 'gd', map = [[<cmd>lua vim.lsp.buf.definition()<cr>]] },
    { key = 'gi', map = [[<cmd>lua vim.lsp.buf.implementation()<cr>]] },
    { key = '<leader>o', map = [[<cmd>LspTroubleToggle<cr>]] },
    { key = '<leader>a', map = [[<cmd>lua vim.lsp.buf.document_highlight()<cr>]] },
    { key = '<leader>c', map = [[<cmd>lua vim.lsp.buf.clear_references()<cr>]] },
    { key = 'F', map = [[<cmd>lua vim.lsp.buf.formatting()<cr>]] },

    -- Other
    { key = '<leader>m', map = [[<cmd>silent !mpcfzf<cr>]] },
}

local insert_mode_maps = {
    { 
        key = '<Tab>',
        map = [[pumvisible() ? "\<C-n>" : "\<Tab>"]],
        options = { noremap = true, silent = true, expr = true }
    },

    { 
        key = '<S-Tab>',
        map = [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]],
        options = { noremap = true, silent = true, expr = true }
    },

    -- { key = '<tab>', map = '(completion_smart_tab)', options = { plug = true } },
    -- { key = '<s-tab>', map = '(completion_smart_s_tab)', options = { plug = true } },

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
