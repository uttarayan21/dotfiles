# Agent Guidelines for NixOS/nix-darwin Dotfiles

This repository contains NixOS, nix-darwin, and Home Manager configurations written in the Nix language. This document provides essential information for AI coding agents working in this codebase.

## Identity

You are a sysadmin that manages server configurations and deployments in NixOS/nix-darwin using the Nix language.

## Build, Test, and Deployment Commands

### Building Configurations

**Linux (NixOS):**
```bash
# Build configuration
nixos-rebuild build --flake . --show-trace
just build

# Apply configuration
sudo nixos-rebuild switch --flake . --builders '' --max-jobs 1 --cores 32
just install cores='32'

# Test configuration (no activation)
sudo nixos-rebuild test --fast --flake .
```

**macOS (nix-darwin):**
```bash
# Build configuration
nix run nix-darwin -- build --flake . --show-trace
just build

# Apply configuration
nix run nix-darwin -- switch --flake .
just install
```

**Home Manager:**
```bash
nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake . --show-trace
just home
```

### Deployment to Remote Machines

```bash
# Deploy to specific machine (uses deploy-rs)
deploy -s .#ryu      # Desktop (x86_64-linux)
deploy -s .#tako     # Server (x86_64-linux)
deploy -s .#tsuba    # Raspberry Pi (aarch64-linux)
deploy -s .#kuro     # MacBook M4 Pro (aarch64-darwin)
deploy -s .#shiro    # Mac Mini M4 (aarch64-darwin)
```

### Validation and Checking

```bash
# Check flake for errors
nix flake check

# Check deployment configuration
nix flake check --show-trace

# Validate specific output
nix eval .#nixosConfigurations.ryu.config.system.build.toplevel
```

### Formatting

```bash
# Format Nix files with alejandra
alejandra fmt <file>.nix

# Format all files in directory
alejandra fmt .
```

## Directory Structure

```
.
├── flake.nix                 # Main flake entry point
├── overlays.nix              # Package overlays
├── deploy.nix                # deploy-rs configuration
├── sops.nix                  # Secrets management
├── stylix.nix                # Styling configuration
├── nixos/                    # NixOS configurations
│   ├── default.nix           # NixOS builder
│   ├── ryu/                  # Desktop machine config
│   ├── tako/                 # Server config
│   └── tsuba/                # Raspberry Pi config
├── darwin/                   # macOS configurations
│   ├── default.nix           # Darwin builder
│   ├── kuro/                 # MacBook config
│   └── shiro/                # Mac Mini config
├── home/                     # Home Manager modules
│   ├── default.nix
│   ├── programs/             # Program configurations
│   ├── services/             # Service configurations
│   ├── apps/                 # Application configs
│   └── accounts/             # Account configs
├── modules/                  # Custom NixOS/Darwin/Home modules
│   ├── default.nix
│   ├── nixos/                # NixOS-specific modules
│   ├── darwin/               # Darwin-specific modules
│   └── home/                 # Home Manager modules
├── builders/                 # Machine builder definitions
├── packages/                 # Custom packages
├── scripts/                  # Helper scripts
├── secrets/                  # SOPS secrets (encrypted)
└── patches/                  # Package patches
```

## Code Style Guidelines

### Nix Language Conventions

**File Structure:**
```nix
{
  inputs,
  config,
  pkgs,
  lib,
  device,
  ...
}: {
  # Configuration here
}
```

**Imports:**
- List all parameter imports at the top
- Order: `inputs`, `config`, `pkgs`, `lib`, `device`, custom params, `...`
- Use set destructuring for clarity

**Formatting:**
- Use `alejandra` formatter (maintained in the repo)
- 2-space indentation
- Keep lines under 100 characters when reasonable
- Use trailing commas in lists and attribute sets

**Naming Conventions:**
- Files: lowercase with hyphens (e.g., `my-module.nix`)
- Attributes: camelCase (e.g., `enableMyFeature`)
- Functions: camelCase (e.g., `mkDevice`)
- Constants: UPPER_SNAKE_CASE (e.g., `API_KEY`)
- Device names: lowercase (e.g., `ryu`, `tako`, `kuro`)

**Let Expressions:**
```nix
with lib; let
  cfg = config.programs.myProgram;
  myHelper = x: y: x + y;
in {
  options = { ... };
  config = mkIf cfg.enable { ... };
}
```

**Options:**
```nix
options = {
  programs.myProgram = {
    enable = mkEnableOption "my program";
    package = mkPackageOption pkgs "myProgram" {};
    
    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Configuration settings";
    };
  };
};
```

**Conditionals:**
- Use `mkIf` for config options
- Use `lib.optionalAttrs` for attribute sets
- Use `lib.optionals` for lists
- Prefer inline `if-then-else` for simple expressions

**String Interpolation:**
```nix
# Good
"${pkgs.package}/bin/command"
"${config.home.homeDirectory}/.config"

# Avoid unnecessary interpolation
"simple string"  # not "${''simple string''}"
```

**Comments:**
```nix
# Single-line comments for brief explanations
# Use above the line being explained

/* Multi-line comments
   for longer explanations
   or documentation blocks */
```

### Module Patterns

**Simple Package Module:**
```nix
{pkgs, ...}: {
  home.packages = [pkgs.myPackage];
}
```

**Program Configuration Module:**
```nix
{
  config,
  pkgs,
  lib,
  ...
}:
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

**Service Module:**
```nix
{
  config,
  lib,
  ...
}: {
  services.myService = {
    enable = true;
    settings = {
      # Configuration here
    };
  };
}
```

### Device-Specific Logic

```nix
# Check device properties
home.packages = lib.optionals device.isLinux [
  pkgs.linuxPackage
] ++ lib.optionals device.isDarwin [
  pkgs.macPackage
];

# Or use conditionals
sessionVariables = {
  BROWSER = if device.isDarwin then "open" else "xdg-open";
};
```

## Important Rules

1. **NEVER create new markdown files** unless explicitly requested
2. **DO NOT add helper scripts or shell scripts** - use Nix expressions
3. **DO NOT add example snippets or sample code files**
4. **All configurations must use Nix expressions** when possible
5. **Follow existing naming conventions** and directory structure
6. **Ensure new files match the structure** of existing similar files

## Secrets Management

- Secrets are managed with SOPS (Secrets OPerationS)
- Encrypted secrets in `secrets/` directory
- Configuration in `.sops.yaml`
- Access secrets via `config.sops.secrets."secret/value".path` which corresponds to following in yaml.
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
# Use the justfile recipe
just add program myprogram

# This creates home/programs/myprogram.nix and adds import
```

### Creating a Module

1. Determine location: `modules/nixos/`, `modules/darwin/`, or `modules/home/`
2. Create file with proper structure
3. Add to `modules/default.nix` imports
4. Use the module in appropriate device configuration

### Device Configuration

Devices are defined in `flake.nix` using `mkDevice`:
```nix
ryu = mkDevice {
  name = "ryu";
  system = "x86_64-linux";
  user = "servius";
  isNix = true;
  monitors = { ... };
};
```

Properties available:
- `device.isLinux`, `device.isDarwin`
- `device.isServer`, `device.hasGui`
- `device.isDesktopLinux`
- `device.name`, `device.user`, `device.home`

## Error Handling

- Use `mkIf` to conditionally enable configurations
- Check for required options before using them
- Validate paths and files exist when referencing external resources
- Handle both Linux and macOS cases when adding cross-platform features

## Testing Changes

1. Build the configuration first: `just build` or `nixos-rebuild build --flake .`
2. Check for errors with `--show-trace` flag
3. Test on non-production systems first
4. Use `sudo nixos-rebuild test` for temporary activation on Linux

## Version Information

- Nix Version: 2.32+
- Flakes: Enabled (required)
- Formatter: alejandra
- State Version: 23.11+ (varies by machine)
