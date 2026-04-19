{
  opts = {
    autoread = true;
    completeopt = "menu,menuone,popup,noselect";
    expandtab = true;
    foldenable = true;
    foldlevel = 99;
    foldlevelstart = 99;
    hidden = true;
    number = true;
    relativenumber = true;
    shell = "sh";
    shiftwidth = 4;
    signcolumn = "yes";
    smartcase = true;
    softtabstop = 4;
    tabstop = 4;
    termguicolors = true;
    undofile = true;
    viewoptions = "cursor,folds";
    wrap = true;
  };
  globals = {
    mapleader = " ";
    localleader = " ";
  };
  colorschemes = {
    catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          notify = true;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
        };
      };
    };
  };
}
