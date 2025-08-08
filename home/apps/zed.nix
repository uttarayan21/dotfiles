{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [nixd nil sleek];
  programs.zed-editor = {
    enable = true;
    extensions = ["catppuccin" "toml" "json" "yaml" "markdown" "python" "javascript" "typescript"];
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-\\" = "workspace::ToggleBottomDock";
          "ctrl-k" = "editor::GoToDefinition";
        };
      }
      {
        context = "Editor";
        use_key_equivalents = true;
        bindings = {
          "ctrl-k" = "editor::GoToDefinition";
          "ctrl-t" = "pane::GoBack";
          "ctrl-l" = "editor::AcceptEditPrediction";
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
        default_profile = "ask";
        default_model = {
          provider = "copilot_chat";
          model = "o4-mini";
        };
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
      theme = "Catppuccin Mocha";
    };
    extraPackages = with pkgs; [nixd nil sleek];
  };
}
