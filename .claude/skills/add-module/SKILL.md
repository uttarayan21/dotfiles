---
name: add-module
description: Add a new NixOS, nix-darwin, or Home Manager module. Use when the user wants to add a new program, app, service, or configuration module.
argument-hint: <path> <name>
allowed-tools: Bash Edit Read Glob Grep
---

# Add a New Module

Create a new Nix module and wire it into the import tree.

## Arguments

- `$0` — The path prefix: `home/apps`, `home/programs`, `home/services`, `ryu/services`, `tako/services`, `kuro/config`, `shiro/config`, etc.
- `$1` — The module name (lowercase-with-hyphens, no `.nix` extension)

## Steps

1. Run `just add $0 $1` to scaffold the file and register the import.
2. Read the created file at the resolved path (see path mapping below).
3. Ask the user what the module should do, then implement it.

## Path mapping

The `just add` command maps paths as follows:
- `home/<category>` → `home/<category>/<name>.nix`
- `ryu|tako|tsuba/<category>` → `nixos/<machine>/<category>/<name>.nix`
- `kuro|shiro/<category>` → `darwin/<machine>/<category>/<name>.nix`

## Valid machines

- **NixOS:** `ryu` (desktop, x86_64-linux), `tako` (server, x86_64-linux), `tsuba` (Raspberry Pi, aarch64-linux)
- **macOS:** `kuro` (MacBook M4 Pro), `shiro` (Mac Mini M4)
- **Home Manager:** `home` (shared across all machines)

## Module patterns

**Simple package module:**
```nix
{pkgs, ...}: {
  home.packages = [pkgs.myPackage];
}
```

**Program with configuration:**
```nix
{pkgs, device, ...}: {
  programs.myProgram = {
    enable = true;
    settings = { };
  };
}
```

**Device-specific logic:**
```nix
{pkgs, lib, device, ...}: {
  home.packages = lib.optionals device.isLinux [pkgs.linuxPkg]
    ++ lib.optionals device.isDarwin [pkgs.macPkg];
}
```

**Custom module with options** (for `modules/nixos/`, `modules/darwin/`, or `modules/home/`):
```nix
{config, pkgs, lib, ...}:
with lib; let
  cfg = config.services.myService;
in {
  options.services.myService = {
    enable = mkEnableOption "myService";
  };
  config = mkIf cfg.enable {
    # ...
  };
}
```

## Rules

- Use `alejandra` formatting (run `alejandra fmt <file>` after editing)
- Follow existing naming: files use `lowercase-with-hyphens`, attributes use `camelCase`
- Use `device.is "name"`, `device.isDarwin`, `device.isLinux`, `device.hasGui` for conditionals
- Use `mkIf` for config options, `lib.optionals` for lists, `lib.optionalAttrs` for attrsets
- Do NOT add shell scripts — use Nix expressions
