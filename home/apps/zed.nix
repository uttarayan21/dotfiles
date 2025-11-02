{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = with pkgs; [
    nixd
    nil
    sleek
  ];
  programs.zed-editor = {
    enable = (device.is "ryu") || (device.is "kuro");
    extensions = [
      "catppuccin"
      "toml"
      "json"
      "yaml"
      "markdown"
      "python"
      "javascript"
      "typescript"
    ];
    userKeymaps = let
      mkMap = keymaps:
        lib.mapAttrsToList (context: bindings: {
          inherit context;
          inherit bindings;
          # use_key_equivalents = true;
        })
        keymaps;
    in
      mkMap {
        "Workspace" = {
          "ctrl-\\" = "workspace::ToggleBottomDock";
          "ctrl-shift-r" = "workspace::ToggleRightDock";
          "ctrl-b" = "workspace::ToggleLeftDock";
          "ctrl-k" = "editor::GoToDefinition";
          "ctrl-n" = null;
          "ctrl-p" = null;
          "ctrl-shift-h" = null;
        };
        "Workspace && !(Editor && vim_mode == insert) && !Terminal" = {
          "space f f" = [
            "task::Spawn"
            {
              task_name = "file_finder";
              reveal_target = "center";
            }
          ];
          "space g g" = [
            "task::Spawn"
            {
              task_name = "live_grep";
              reveal_target = "center";
            }
          ];
          "space f g" = [
            "task::Spawn"
            {
              task_name = "file_manager";
              reveal_target = "center";
            }
          ];
        };
        "Editor" = {
          "ctrl-k" = "editor::GoToDefinition";
          "ctrl-t" = "pane::GoBack";
          "ctrl-l" = "editor::AcceptEditPrediction";
          "ctrl-\\" = "workspace::ToggleBottomDock";
          "ctrl-b" = "workspace::ToggleLeftDock";
        };
        "Editor && vim_mode != insert && !Terminal" = {
          "space n" = "pane::ActivateNextItem";
          "space p" = "pane::ActivatePreviousItem";
          "space space" = "pane::ActivateLastItem";
          "space q" = "pane::CloseActiveItem";
          "space r r" = "editor::Rename";
          "space a" = "editor::ToggleCodeActions";
        };
        "vim_mode == insert" = {
          "ctrl-k" = "editor::GoToDefinition";
          "ctrl-l" = "editor::AcceptEditPrediction";
          "ctrl-h" = "editor::Backspace";
        };
      };
    userSettings = {
      features = {
        edit_prediction_provider = "copilot";
      };
      agent = {
        default_profile = "write";
        default_model = {
          provider = "copilot_chat";
          model = "claude-sonnet-4";
        };
        always_allow_tool_actions = true;
      };
      vim_mode = true;
      relative_line_numbers = true;
      telemetry = {
        metrics = false;
      };
      buffer_font_size = lib.mkDefault 15;
      language_models = {
      };
      terminal = {
        shell = {
          program = "${pkgs.fish}/bin/fish";
        };
      };
      lsp = {
        nixd = {
          binary = {
            path = "${pkgs.nixd}/bin/nixd";
          };
        };
        nil = {
          initialization_options = {
            formatting = {
              command = [
                "${lib.getExe pkgs.alejandra}"
                "--quiet"
                "--"
              ];
            };
          };
          binary = {
            path = "${pkgs.nil}/bin/nil";
          };
        };
      };
      theme = lib.mkForce "Catppuccin Mocha";
    };
    userTasks = let
      zed =
        if pkgs.stdenv.isDarwin
        then "zed"
        else "${lib.getExe pkgs.zed-editor}";
      tv = "${lib.getExe pkgs.television}";
      yazi = "${lib.getExe pkgs.yazi}";
    in [
      {
        label = "file_finder";
        command = "${zed} \"$(${tv} files)\"";
        hide = "always";
        allow_concurrent_runs = true;
        use_new_terminal = true;
      }
      {
        label = "live_grep";
        command = "${tv} text | read -alz res; and ${zed} $res";
        hide = "always";
        allow_concurrent_runs = false;
        use_new_terminal = false;
        shell = {
          with_arguments = {
            program = "fish";
            args = ["--no-config"];
          };
        };
      }
      {
        label = "file_manager";
        command = "${yazi} --chooser-file /dev/stdout \"$ZED_DIRNAME\" | read -alz res;and ${zed} $res";
        hide = "always";
        allow_concurrent_runs = false;
        use_new_terminal = false;
        shell = {
          with_arguments = {
            program = "fish";
            args = ["--no-config"];
          };
        };
      }
    ];
    extraPackages = with pkgs; [
      nixd
      nil
      sleek
      television
    ];
  };
}
