# Agent Guidelines for NixOS/nix-darwin Dotfiles

This repository contains NixOS, nix-darwin, and Home Manager configurations in Nix. You are a sysadmin managing server configurations and deployments.

## Build, Test, and Deployment Commands

### Build and Apply Configurations

**Linux (NixOS):**
```bash
just build                          # Build configuration
just install cores='32'             # Apply with 32 cores
sudo nixos-rebuild test --fast --flake .  # Test without activation
sudo nixos-rebuild switch --rollback --flake .  # Rollback
```

**macOS (nix-darwin):**
```bash
just build                          # Build configuration
just install                        # Apply configuration
```

**Home Manager:**
```bash
just home
```

### Deploy to Remote Machines (deploy-rs)

```bash
deploy -s .#ryu      # Desktop (x86_64-linux)
deploy -s .#tako     # Server (x86_64-linux)
deploy -s .#tsuba    # Raspberry Pi (aarch64-linux)
deploy -s .#kuro     # MacBook M4 Pro (aarch64-darwin)
deploy -s .#shiro    # Mac Mini M4 (aarch64-darwin)
```

### Validation and Formatting

```bash
nix flake check --show-trace        # Check flake for errors
alejandra fmt .                     # Format all files
alejandra fmt <file>.nix            # Format single file
```

## Directory Structure

- `flake.nix` - Main entry point, device definitions
- `nixos/` - NixOS machine configs (ryu, tako, tsuba)
- `darwin/` - macOS machine configs (kuro, shiro)
- `home/` - Home Manager modules (programs/, services/, apps/)
- `modules/` - Custom modules (nixos/, darwin/, home/)
- `secrets/` - SOPS encrypted secrets
- `overlays.nix`, `deploy.nix`, `sops.nix`, `stylix.nix` - Config files

## Code Style Guidelines

### Nix Language Conventions

**File Structure:**
```nix
{inputs, config, pkgs, lib, device, ...}: {
  # Configuration here
}
```

**Imports:**
- Order: `inputs`, `config`, `pkgs`, `lib`, `device`, custom params, `...`
- Use set destructuring for clarity

**Formatting:**
- Use `alejandra` formatter (run before committing)
- 2-space indentation
- Trailing commas in lists and attribute sets

**Naming Conventions:**
- Files: lowercase-with-hyphens (e.g., `my-module.nix`)
- Attributes: camelCase (e.g., `enableMyFeature`)
- Functions: camelCase (e.g., `mkDevice`)
- Constants: UPPER_SNAKE_CASE (e.g., `API_KEY`)
- Device names: lowercase (e.g., `ryu`, `tako`)

**Let Expressions:**
```nix
with lib; let
  cfg = config.programs.myProgram;
in {
  options = { ... };
  config = mkIf cfg.enable { ... };
}
```

**Conditionals:**
- Use `mkIf` for config options
- Use `lib.optionalAttrs` for attribute sets
- Use `lib.optionals` for lists

### Module Patterns

**Simple Package Module:**
```nix
{pkgs, ...}: {
  home.packages = [pkgs.myPackage];
}
```

**Program Configuration Module:**
```nix
{config, pkgs, lib, ...}:
with lib; let
  cfg = config.programs.myProgram;
in {
  options.programs.myProgram = {
    enable = mkEnableOption "myProgram";
  };
  config = mkIf cfg.enable {
    home.packages = [pkgs.myProgram];
  };
}
```

**Device-Specific Logic:**
```nix
home.packages = lib.optionals device.isLinux [pkgs.linuxPackage]
  ++ lib.optionals device.isDarwin [pkgs.macPackage];

sessionVariables.BROWSER = if device.isDarwin then "open" else "xdg-open";
```

## Important Rules

1. **NEVER create markdown files** unless explicitly requested
2. **DO NOT add shell scripts** - use Nix expressions
3. **All configurations must use Nix expressions** when possible
4. **Follow existing naming conventions** and directory structure
5. Create custom application entries in `~/.local/share/applications/{appname}.desktop`

## Secrets Management

- Secrets are managed with SOPS in `secrets/` directory
- Encrypted secrets in `secrets/` directory
- Configuration in `.sops.yaml`
- Access via `config.sops.secrets."secret/value".path`
    ```yaml
    foo:
        bar: somesecret
    ```
    The path is the file that contains `somesecret`
- Add new secrets using `sops set` 
  Example
  ```bash
    openssl rand -hex 32 | tr -d '\n' | jq -sR | sops set --value-stdin secrets/secrets.yaml '["foo"]["bar"]'
  ```
  This will add a randomly generated secret to the sops file


## Common Patterns

### Adding a New Program

```bash
just add program myprogram  # Creates home/programs/myprogram.nix and adds import
```

### Creating a Module

1. Determine location: `modules/nixos/`, `modules/darwin/`, or `modules/home/`
2. Create file with proper structure
3. Add to `modules/default.nix` imports

### Device Configuration

Devices are defined in `flake.nix` using `mkDevice`. Properties available:
- `device.isLinux`, `device.isDarwin`, `device.isArm`
- `device.isServer`, `device.hasGui`, `device.isDesktopLinux`
- `device.name`, `device.user`, `device.home`

## Error Handling

- Use `mkIf` to conditionally enable configurations
- Handle both Linux and macOS cases when adding cross-platform features

## Testing Changes

1. Build first: `just build` or `nixos-rebuild build --flake .`
2. Check for errors with `--show-trace` flag

## Version Information

- Nix Version: 2.32+
- Flakes: Enabled (required)
- Formatter: alejandra
- State Version: (varies by machine & never change this)
