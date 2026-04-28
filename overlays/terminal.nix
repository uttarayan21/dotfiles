{inputs, ...}: final: prev: {
  tmuxPlugins =
    prev.tmuxPlugins
    // {
      tmux-super-fingers = final.pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-super-fingers";
        version = "v1-2024-02-14";
        src = inputs.tmux-super-fingers-src;
      };
    };
  tmux-float = inputs.tmux-float.packages.${prev.stdenv.hostPlatform.system}.default;
  zellijPlugins = {
    zjstatus = inputs.zjstatus.packages.${prev.stdenv.hostPlatform.system}.default;
  };
}
