{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    nixd
    nil
    sleek
  ];
  programs.zed-editor = {
    enable = true;
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
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-\\" = "workspace::ToggleBottomDock";
          "ctrl-shift-r" = "workspace::ToggleRightDock";
          "ctrl-k" = "editor::GoToDefinition";
          "ctrl-n" = null;
          "ctrl-p" = null;
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
        };
      }
      {
        context = "Editor";
        use_key_equivalents = true;
        bindings = {
          "ctrl-shift-r" = "workspace::ToggleRightDock";
          "ctrl-k" = "editor::GoToDefinition";
          "ctrl-t" = "pane::GoBack";
          "ctrl-l" = "editor::AcceptEditPrediction";
          "ctrl-\\" = "workspace::ToggleBottomDock";
        };
      }
      {
        context = "vim_mode == insert";
        bindings = {
          "ctrl-k" = "editor::GoToDefinition";
          "ctrl-l" = "editor::AcceptEditPrediction";
        };
      }
    ];
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
      buffer_font_size = 15;
      language_models = {
        ollama = {
          api_url = "https://ollama.ryu.darksailor.dev";
          available_models = [
            {
              name = "qwen3:30b-a3b";
              display_name = "Qwen3 MoE (30b-a3b)";
              max_tokens = 32768;
              supports_tools = true;
              supports_thinking = false;
              supports_images = false;
            }
          ];
        };
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
          binary = {
            path = "${pkgs.nil}/bin/nil";
          };
        };
      };
      theme = "Catppuccin Mocha";
    };
    userTasks = [
      {
        label = "file_finder";
        command = "${lib.getExe pkgs.zed-editor} \"$(tv files)\"";
        hide = "always";
        allow_concurrent_runs = true;
        use_new_terminal = true;
      }
      {
        label = "live_grep";
        command = "tv text | read -alz res; and ${lib.getExe pkgs.zed-editor} $res";
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
