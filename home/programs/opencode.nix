{
  device,
  lib,
  config,
  ...
}:
lib.optionalAttrs (device.is "ryu" || device.is "kuro" || device.is "shiro") {
  sops.secrets."opencode/password" = {};
  sops.secrets."opencode/username" = {};

  sops.templates."opencode-web.env".content = ''
    OPENCODE_SERVER_PASSWORD=${config.sops.placeholder."opencode/password"}
    OPENCODE_SERVER_USERNAME=${config.sops.placeholder."opencode/username"}
  '';

  programs.opencode = {
    enable = true;
    web = {
      enable = true;
      environmentFile = config.sops.templates."opencode-web.env".path;
    };
    tui = {
      settings.provider = {
        ollama = {
          models = {
            "glm-4.7-flash" = {
              # "_launch" = true;
              name = "glm-4.7-flash";
            };
          };
          name = "Ollama (local)";
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "https://ollama.darksailor.dev/v1";
          };
        };
      };
    };
    skills = {
      nix = ''
        ---
        name: nix
        description: Nix / NixOS related modifications
        ---
        **Formatting:**
        - Use `alejandra` formatter (run before committing)

        **Common Patterns:**
        Writing a new module must be like this
        ```nix
        with lib; let
          cfg = config.programs.myProgram;
        in {
          options.programs.myProgram = {
            enable = mkEnableOption "myProgram";
          };
          config = mkIf cfg.enable {
            home.packages = [ pkgs.myProgram ];
          };
        }
        ```
        Save the modules under modules/{home, darwin, nixos} folders
        And then add a new file under home/my_program.nix
        ```nix
        {...}: {
            imports = [path/to/my_module.nix];
            programs.myModule.enable = true;
        }
        ```

        **Device-Specific Logic:**
        ```nix
        home.packages = lib.optionals device.isLinux [ pkgs.linuxPackage ] ++ lib.optionals device.isDarwin [ pkgs.macPackage ];
        # if the device doesn't h

        **Instructions:**
        When working on nixos / darwin configurations do not run `nix check` instead try to build the derivation.
        When working on nix derivations try to compile on local machine only (use --builders \'\')

        **Resources:**
        1. https://wiki.nixos.org/wiki/Packaging/Quirks_and_Caveats
        ```
      '';
      rust = ''
        ## Rust Guidelines

        **Code Organization:**
        - One module per file
        - Use `foo.rs` and `foo` for module directories
        - Re-export public API at module root

        **Naming Conventions:**
        - Types: PascalCase (e.g., `HttpClient`)
        - Functions/variables: snake_case (e.g., `parse_config`)
        - Constants: SCREAMING_SNAKE_CASE (e.g., `MAX_RETRIES`)
        - Lifetimes: short lowercase (e.g., `'a`, `'ctx`)

        **Error Handling:**
        - Use `Result<T, E>` for recoverable errors
        - Use `thiserror` for custom error types
        - Avoid `unwrap()` and `expect()` in production code

        **Idiomatic Patterns:**
        ```rust
        // Use Option/Result combinators
        user.name.clone().unwrap_or_default();

        // Use pattern matching exhaustively
        match result {
            Ok(value) => value,
            Err(e) => return Err(e.into()),
        }

        // Prefer iterators over explicit loops
        items.iter().filter(|x| x.active).map(|x| x.id).collect()
        std::env::args().skip(1).collect::<Vec<String>>()
        ```

        **Safety:**
        - Avoid `unsafe` unless absolutely necessary
        - Document safety invariants for `unsafe` blocks
        - Use `#[allow(dead_code)]` sparingly

        **Dependencies:**
        - Specify versions in `Cargo.toml`
        - Use `cargo edit` for dependency management
        - Run `cargo outdated` regularly
        - Use rust edition 2024
        - If there is a flake.nix in the repo use the default devShell

        **Testing:**
        - Write unit tests in same file with `#[cfg(test)]`
        - Write integration tests in `tests/` directory
        - Use `cargo test` for running tests
        - Use `cargo tarpaulin` for coverage

        **Clippy:**
        - Run `cargo clippy -- -D warnings`
        - Address all clippy warnings before committing

      '';
    };
  };
}
