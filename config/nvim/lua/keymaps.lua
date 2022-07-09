vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
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
    { key = '<leader>v', map = [[<cmd>CHADopen<cr>]] },

    -- " Find files using Telescope command-line sugar.
    { key = '<leader>ff', map = [[<cmd>lua require('telescope.builtin').find_files()<cr>]] },
    { key = '<leader>gg', map = [[<cmd>lua require('telescope.builtin').live_grep()<cr>]] },
    { key = '<leader>;', map = [[<cmd>lua require('telescope.builtin').buffers()<cr>]] },
    { key = '<leader>fh', map = [[<cmd>lua require('telescope.builtin').help_tags()<cr>]] },
    { key = '<leader>gB', map = [[<cmd>Git blame<cr>]] },

    { key = '<leader>rd', map = [[<cmd>RustDebuggables<cr>]] },
    { key = '<leader>rr', map = [[<cmd>RustRunnables<cr>]] },

    -- Session
    { key = '<leader>ss', map = [[<cmd>SessionSave<cr>]] },
    { key = '<leader>sl', map = [[<cmd>SessionLoad<cr>]] },

    -- lsp
    { key = 'K', map = [[<cmd>lua vim.lsp.buf.hover()<cr>]] },
    { key = '<C-k>', map = [[<cmd>lua vim.lsp.buf.definition()<cr>]] },
    { key = 'gi', map = [[<cmd>lua vim.lsp.buf.implementation()<cr>]] },
    { key = '<leader>o', map = [[<cmd>TroubleToggle<cr>]] },
    -- { key = '<leader>a', map = [[<cmd>lua vim.lsp.buf.document_highlight()<cr>]] },
    -- { key = '<leader>c', map = [[<cmd>lua vim.lsp.buf.clear_references()<cr>]] },
    { key = '<leader>"', map = [["+]] },
    { key = 'F', map = [[<cmd>lua vim.lsp.buf.formatting()<cr>]] },
    { key = 'T', map = [[<cmd>lua require'lsp_extensions'.inlay_hints()<cr>]] },

    -- { key = '<C-W-%>', map = [[<cmd>vsplit<cr>]] },

    -- Other
    { key = '<leader>m', map = [[<cmd>silent !mpcfzf<cr>]] },
    { key = '<leader>l', map = [[<cmd>Glow<cr>]] },
}


local insert_mode_maps = {
    { key = '<C-j>', map = '<ESC>' },
    { key = "<C-l>", map = 'copilot#Accept("<CR>")', options = { silent = true, expr = true } },
    { key = "<C-m>", map = 'copilot#Accept("<CR>")', options = { silent = true, expr = true } },
}


for idx = 1, #normal_mode_maps do
    if normal_mode_maps[idx].options then
        local options = normal_mode_maps[idx].options
        vim.api.nvim_set_keymap('n', normal_mode_maps[idx].key, normal_mode_maps[idx].map, options)
    else
        vim.api.nvim_set_keymap('n', normal_mode_maps[idx].key, normal_mode_maps[idx].map, options)
    end
end

for idx = 1, #insert_mode_maps do
    if insert_mode_maps[idx].options then
        local options = insert_mode_maps[idx].options
        vim.api.nvim_set_keymap('i', insert_mode_maps[idx].key, insert_mode_maps[idx].map, options)
    else
        vim.api.nvim_set_keymap('i', insert_mode_maps[idx].key, insert_mode_maps[idx].map, options)
    end
end
