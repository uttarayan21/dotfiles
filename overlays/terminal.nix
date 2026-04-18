{inputs, ...}: final: prev: {
  tmuxPlugins =
    prev.tmuxPlugins
    // {
      tmux-super-fingers = final.pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-super-fingers";
        version = "v1-2024-02-14";
        src = final.pkgs.fetchFromGitHub {
          owner = "artemave";
          repo = "tmux_super_fingers";
          rev = "518044ef78efa1cf3c64f2e693fef569ae570ddd";
          sha256 = "sha256-iKfx9Ytk2vSuINvQTB6Kww8Vv7i51cFEnEBHLje+IJw=";
        };
      };
    };
  tmux-float = inputs.tmux-float.packages.${prev.stdenv.hostPlatform.system}.default;
  zellijPlugins = {
    zjstatus = inputs.zjstatus.packages.${prev.stdenv.hostPlatform.system}.default;
  };
}
