{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.mayichat;
  yamlFormat = pkgs.formats.yaml {};
  fishIntegration = ''
    function _aichat_fish
        set -l _old (commandline)
        if test -n $_old
            echo -n "⌛"
            commandline -f repaint
            commandline (aichat -e $_old)
        end
    end
    bind \co _aichat_fish'';
  nuIntegration = ''
    def _aichat_nushell [] {
        let _prev = (commandline)
        if ($_prev != "") {
            print '⌛'
            commandline edit -r (aichat -e $_prev)
        }
    }

    $env.config.keybindings = ($env.config.keybindings | append {
            name: aichat_integration
            modifier: control
            keycode: char_o
            mode: [emacs, vi_insert]
            event:[
                {
                    send: executehostcommand,
                    cmd: "_aichat_nushell"
                }
            ]
        }
    )
  '';
  bashIntegration = ''
    _aichat_bash() {
        if [[ -n "$READLINE_LINE" ]]; then
            READLINE_LINE=$(aichat -e "$READLINE_LINE")
            READLINE_POINT=''${#READLINE_LINE}
        fi
    }
    bind -x '"\co": _aichat_bash'
  '';
  zshIntegration = ''
    _aichat_zsh() {
        if [[ -n "$BUFFER" ]]; then
            local _old=$BUFFER
            BUFFER+="⌛"
            zle -I && zle redisplay
            BUFFER=$(aichat -e "$_old")
            zle end-of-line
        fi
    }
    zle -N _aichat_zsh
    bindkey '\co' _aichat_zsh
  '';
in {
  options = {
    programs.mayichat = {
      enable = mkEnableOption "aichat";
      package = mkPackageOption pkgs "aichat" {};

      enableFishIntegration = mkEnableOption "Fish integration" // {default = true;};
      enableBashIntegration = mkEnableOption "Bash integration" // {default = true;};
      enableZshIntegration = mkEnableOption "Zsh integration" // {default = true;};
      enableNushellIntegration = mkEnableOption "Nushell integration" // {default = true;};

      settings = lib.mkOption {
        type = yamlFormat.type;
        description = "Options";
      };
    };
  };

  config = let
    api_key_files = concatStringsSep " " (builtins.map (client: ''--run "export ${lib.toUpper client.name}_API_KEY=\`cat -v ${client.api_key_file}\`"'') (builtins.filter (client: (builtins.hasAttr "api_key_file" client)) cfg.settings.clients));
    api_key_cmds = concatStringsSep " " (builtins.map (client: ''--run "export ${lib.toUpper client.name}_API_KEY=\`${client.api_key_cmd}\`"'') (builtins.filter (client: (builtins.hasAttr "api_key_cmd" client)) cfg.settings.clients));

    aichat-wrapped = pkgs.symlinkJoin {
      name = "aichat";
      paths = [
        cfg.package
      ];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/aichat ${api_key_files} ${api_key_cmds}
      '';
    };
  in {
    home.packages = mkIf cfg.enable [aichat-wrapped];

    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration fishIntegration;
    programs.bash.initExtra = mkIf cfg.enableBashIntegration bashIntegration;
    programs.zsh.initExtra = mkIf cfg.enableZshIntegration zshIntegration;
    programs.nushell.extraConfig = mkIf cfg.enableNushellIntegration nuIntegration;

    xdg.configFile."aichat/config.yaml".source =
      yamlFormat.generate "config.yaml" cfg.settings;
  };
}
