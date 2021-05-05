" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time("Luarocks path setup", true)
local package_path_str = "/home/fs0c131y/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/fs0c131y/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/fs0c131y/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/fs0c131y/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/fs0c131y/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  ["comfortable-motion.vim"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/comfortable-motion.vim"
  },
  ["completion-nvim"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/completion-nvim"
  },
  fzf = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\1\2*\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\15statusline\frequire\0" },
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["lsp-trouble.nvim"] = {
    config = { "\27LJ\1\0029\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/lsp-trouble.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\1\0024\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\2#\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\blsp\frequire\0" },
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  sonokai = {
    config = { "\27LJ\1\2+\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\16colorscheme\frequire\0" },
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/sonokai"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-speeddating"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/vim-speeddating"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-vinegar"] = {
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/vim-vinegar"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/fs0c131y/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time("Defining packer_plugins", false)
-- Config for: lspkind-nvim
time("Config for lspkind-nvim", true)
try_loadstring("\27LJ\1\0024\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time("Config for lspkind-nvim", false)
-- Config for: nvim-lspconfig
time("Config for nvim-lspconfig", true)
try_loadstring("\27LJ\1\2#\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\blsp\frequire\0", "config", "nvim-lspconfig")
time("Config for nvim-lspconfig", false)
-- Config for: lsp-trouble.nvim
time("Config for lsp-trouble.nvim", true)
try_loadstring("\27LJ\1\0029\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\ftrouble\frequire\0", "config", "lsp-trouble.nvim")
time("Config for lsp-trouble.nvim", false)
-- Config for: galaxyline.nvim
time("Config for galaxyline.nvim", true)
try_loadstring("\27LJ\1\2*\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\15statusline\frequire\0", "config", "galaxyline.nvim")
time("Config for galaxyline.nvim", false)
-- Config for: nvim-colorizer.lua
time("Config for nvim-colorizer.lua", true)
try_loadstring("\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time("Config for nvim-colorizer.lua", false)
-- Config for: which-key.nvim
time("Config for which-key.nvim", true)
try_loadstring("\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time("Config for which-key.nvim", false)
-- Config for: sonokai
time("Config for sonokai", true)
try_loadstring("\27LJ\1\2+\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\16colorscheme\frequire\0", "config", "sonokai")
time("Config for sonokai", false)
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
