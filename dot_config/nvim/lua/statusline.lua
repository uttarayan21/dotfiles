local vim = vim
local gl = require('galaxyline')

local condition = require('galaxyline.condition')
-- local diagnostic = require('galaxyline.provider_diagnostic')
local diagnostic = require('lsp-status.diagnostics')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
-- local extension = require('galaxyline.provider_extensions')
-- local colors = require('galaxyline.colors')
-- local buffer = require('galaxyline.provider_buffer')
-- local whitespace = require('galaxyline.provider_whitespace')
-- local lspclient = require('galaxyline.provider_lsp')
local lsp_status = require('lsp-status')


-- local gls = gl.section
gl.short_line_list = { 'defx' }

-- from sonokai theme (https://github.com/sainnhe/sonokai/blob/master/autoload/sonokai.vim)
local colors = {
    dark_black  = '#151515',
    black       = '#181819',

    bg          = '#151515', -- same as dark_black
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

    yellow      = '#e7c664',
    diff_yellow = '#4e432f',

    fg          = '#e2e2e3',

    red         = '#fc5d7c',
    orange      = '#f39660',
    green       = '#9ed072',
    blue        = '#76cce0',
    purple      = '#b39df3',
    grey        = '#7f8490',
    none        = 'NONE',
}


local mode_color = function()
    local mode_colors = {
        n       = colors.blue,
        i       = colors.green,
        c       = colors.yellow,
        V       = colors.purple,
        ['']    = colors.purple,
        v       = colors.purple,
        R       = colors.red,
    }

    local color = mode_colors[vim.fn.mode()]

    if color == nil then
        color = colors.red
    end

    return color
end


local gls = gl.section

gls.left[1] = {
    ViMode = {
        provider = function()
            local alias = {
                n = 'NORMAL',
                i = 'INSERT',
                c = 'COMMAND',
                V = 'VISUAL',
                [''] = 'VISUAL',
                v = 'VISUAL',
                R = 'REPLACE',
            }
            vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color())
            local alias_mode = alias[vim.fn.mode()]
            if alias_mode == nil then
                alias_mode = vim.fn.mode()
            end
            return '▋ '..alias_mode..' '
        end,
        highlight = { colors.fg , colors.bg2 },
        separator = '',
        separator_highlight = { colors.bg2 ,
                function()
                    if condition.check_git_workspace() then
                        return colors.bg1
                    else
                        return colors.dark_black
                    end
                end
        },

    }
}

gls.left[2] = {
    GitBranch = {
        provider = function() return vcs.get_git_branch()..' ' end,
        condition = condition.check_git_workspace,
        highlight = { colors.purple , colors.bg1 },
        icon = '  ',
        separator = '',
        separator_highlight = { colors.bg1 , colors.dark_black },
    }
}

gls.left[3] = {
  ShowLspStatus = {
    provider = lsp_status.status,
    highlight = { colors.grey , colors.dark_black, 'bold' }
  }
}


-- Right Side
-- gls.right[1]= {
--   FileFormat = {
--     provider = function() return ' '..fileinfo.get_file_format()..' ' end,
--     highlight = { colors.purple, colors.bg3 },
--     separator = '',
--     separator_highlight = { colors.bg3, colors.dark_black },
--   }
-- }


gls.right[1] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg}
  }
}
gls.right[2] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow,colors.bg},
  }
}

gls.right[3] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.cyan,colors.bg},
  }
}

gls.right[4] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.bg},
  }
}

gls.right[5] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = { colors.grey , colors.bg3 },
    separator = '',
    separator_highlight = { colors.bg3, colors.dark_black },
  },
}
gls.right[6] = {
  PerCent = {
    provider = 'LinePercent',
    highlight = { colors.blue, colors.bg1 },
    separator = '',
    separator_highlight = { colors.bg1 , colors.bg3 },
  }
}

