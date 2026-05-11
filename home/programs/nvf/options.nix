{
  programs.nvf.settings.vim = {
    options = {
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
      maplocalleader = " ";
    };

    lineNumberMode = "relNumber";
  };
}
