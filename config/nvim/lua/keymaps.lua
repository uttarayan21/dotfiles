---@diagnostic disable: redefined-local
local vim = vim
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
-- nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
-- nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
-- nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
-- nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
-- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
-- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
-- nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>


local options = { noremap = true, silent = true }
local normal_mode_maps = {
    -- toggles
    { key = '<F2>',       map = [[<cmd>set number! relativenumber!<cr>]] },

    -- dap
    { key = '<F5>',       map = [[<cmd>lua require'dap'.continue()<cr>]] },
    { key = '<F10>',      map = [[<cmd>lua require'dap'.step_over()<cr>]] },
    { key = '<F11>',      map = [[<cmd>lua require'dap'.step_into()<cr>]] },
    { key = '<F12>',      map = [[<cmd>lua require'dap'.step_out()<cr>]] },
    { key = '<Leader>bb', map = [[<cmd>lua require'dap'.toggle_breakpoint()<cr>]] },
    { key = '<Leader>B',  map = [[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]] },
    {
        key = '<Leader>lp',
        map = [[<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]]
    },
    { key = '<Leader>dr',       map = [[<cmd>lua require'dap'.repl.open()<cr>]] },
    { key = '<Leader>dl',       map = [[<cmd>lua require'dap'.run_last()<cr>]] },

    -- navigation
    { key = '<leader><leader>', map = [[<c-^>]] },
    { key = '<leader>n',        map = [[<cmd>bnext<cr>]] },
    { key = '<leader>p',        map = [[<cmd>bprev<cr>]] },
    { key = '<leader>q',        map = [[<cmd>bw<cr>]] },
    { key = '<leader>v',        map = [[<cmd>CHADopen<cr>]] },

    -- " Find files using Telescope command-line sugar.
    { key = '<leader>ff',       map = [[<cmd>lua require('telescope.builtin').find_files()<cr>]] },
    { key = '<leader>gg',       map = [[<cmd>lua require('telescope.builtin').live_grep()<cr>]] },
    { key = '<leader>;',        map = [[<cmd>lua require('telescope.builtin').buffers()<cr>]] },
    { key = '<leader>fh',       map = [[<cmd>lua require('telescope.builtin').help_tags()<cr>]] },
    { key = '<leader>gB',       map = [[<cmd>Git blame<cr>]] },
    { key = '<leader>rd',       map = [[<cmd>RustDebuggables<cr>]] },
    -- { key = '<leader>rr',       map =  vim.cmd.RustLsp('runnables') },
    { key = 'vff',              map = [[<cmd>vertical Gdiffsplit<cr>]] },
    -- { key = 'vff!',             map = [[<cmd>vertical Gdiffsplit!<cr>]] },
    -- { key = 'ssr',              map = [[<cmd>lua require'rust-tools'.ssr.ssr(query)<cr>]] },
    { key = 'ssr',              map = [[<cmd>lua require("ssr").open()<cr>]] },
    { key = '<C-\\>',           map = [[<cmd>ToggleTerm<cr>]] },

    -- Session
    { key = '<leader>ss',       map = [[<cmd>SessionSave<cr>]] },
    { key = '<leader>sl',       map = [[<cmd>SessionLoad<cr>]] },

    -- lsp
    -- { key = 'K',                map = [[<cmd>lua vim.lsp.buf.hover()<cr>]] },
    -- vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc')
    { key = 'K',                map = [[<cmd>Lspsaga hover_doc<cr>]] },
    { key = '<C-k>',            map = [[<cmd>lua vim.lsp.buf.definition()<cr>]] },
    { key = 'gi',               map = [[<cmd>lua vim.lsp.buf.implementation()<cr>]] },
    { key = '<leader>o',        map = [[<cmd>TroubleToggle<cr>]] },
    { key = '<leader>dd',       map = [[<cmd>lua require'dapui'.toggle()<cr>]] },

    -- { key = '<leader>a', map = [[<cmd>lua vim.lsp.buf.document_highlight()<cr>]] },
    -- { key = '<leader>c', map = [[<cmd>lua vim.lsp.buf.clear_references()<cr>]] },
    { key = '<leader>"',        map = [["+]] },
    { key = 'F',                map = [[<cmd>lua vim.lsp.buf.format { async = true }<cr>]] },
    { key = '<C-W>%',           map = [[<cmd>vsplit<cr>]] },
    { key = '<C-W>"',           map = [[<cmd>split<cr>]] },
    { key = '<C-l>',            map = [[<cmd>:SymbolsOutline<cr>]] },
    { key = '<leader>a',        map = [[<cmd>:lua vim.lsp.buf.code_action()<cr>]] },

    -- Other
    { key = '<leader>m',        map = [[<cmd>silent !mpcfzf<cr>]] },
    -- { key = '<leader>l',
    --     map = [[<cmd>lua require('telescope.builtin').lsp_references({include_current_line = true, fname_width = 40})<cr>]] },
    {
        key = '<leader>l',
        map = [[<cmd>Lspsaga finder<cr>]]
    },
    {
        key = '<leader>i',
        map = [[<cmd>lua require('telescope.builtin').lsp_incoming_calls({fname_width = 40})<cr>]]
    },
    {
        key = '<leader>e',
        map = [[<Plug>RestNvim<cr>]]
    },
    { key = '<leader>u', map = [[<cmd>Telescope undo<cr>]] },
    { key = '<C-c>',     map = [[<cmd>Telescope commands<cr>]] },
    -- { key = '<ScrollWheelDown>', map = [[<cmd>call comfortable_motion#flick(40)<cr>]], options = { silent = true } },
    -- { key = '<ScrollWheelUp>', map = [[<cmd>call comfortable_motion#flick(-40)<cr>]], options = { silent = true } },

}


local insert_mode_maps = {
    { key = '<C-j>', map = '<ESC>' },
    -- { key = "<C-l>", map = 'copilot#Accept("<CR>")',       options = { silent = true, expr = true } },
    -- { key = "<C-m>", map = 'copilot#Accept("<CR>")',       options = { silent = true, expr = true } },
    -- { key = '<C-c>', map = [[<cmd>Telescope commands<cr>]] },
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
