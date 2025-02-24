{pkgs, ...}: {
  programs = {
    # Only for checking markdown previews
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles = {
        default = {
          extensions = with pkgs.vscode-extensions; [
            shd101wyy.markdown-preview-enhanced
            asvetliakov.vscode-neovim
          ];
        };
      };
    };
  };
}
