{
  pkgs,
  lib,
  ...
}: {
  programs.nvf.settings.vim.autocmds = [
    {
      event = ["BufEnter" "BufWinEnter"];
      pattern = ["*.norg"];
      command = "set conceallevel=3";
    }
    {
      event = ["BufEnter" "BufWinEnter"];
      pattern = ["*.pest"];
      command = "setlocal commentstring=//%s";
    }
    {
      event = ["BufWinLeave"];
      pattern = ["?*"];
      command = "mkview!";
    }
    {
      event = ["BufWinEnter"];
      pattern = ["?*"];
      command = "silent! loadview!";
    }
    {
      event = ["FileType"];
      pattern = ["json"];
      callback = lib.generators.mkLuaInline ''
        function(ev)
          vim.bo[ev.buf].formatprg = "${pkgs.jq}/bin/jq"
        end
      '';
    }
  ];
}
