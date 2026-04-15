#!/usr/bin/env python3
"""List enabled programs and services per host across NixOS, nix-darwin, and home-manager."""

import json
import subprocess
import sys
from collections import defaultdict

FLAKE = sys.argv[1] if len(sys.argv) > 1 else "."

NIXOS_HOSTS = ["ryu", "tako", "tsuba"]
DARWIN_HOSTS = ["kuro", "shiro"]

# Nix expression to find enabled options using options.*.isDefined (robust for NixOS)
NIX_SYSTEM_ENABLED_EXPR = """sys: let
  opts = sys.options.{section};
  cfg = sys.config.{section};
  names = builtins.attrNames opts;
  check = n: let
    r = builtins.tryEval (
      builtins.isAttrs opts.${{n}}
      && builtins.hasAttr "enable" opts.${{n}}
      && opts.${{n}}.enable.isDefined or false
      && cfg.${{n}}.enable
    );
  in r.success && r.value;
in builtins.filter check names"""

# Simpler expression for darwin (fewer options, no removed-option aborts)
NIX_DARWIN_ENABLED_EXPR = """svcs: let
  names = builtins.attrNames svcs;
  results = map (n: let r = builtins.tryEval (svcs.${{n}}.enable or false); in {{ name = n; val = r.value or null; }}) names;
in map (r: r.name) (builtins.filter (r: r.val == true) results)"""

# Home-manager expression (not passed through .format(), so use single braces)
NIX_HM_ENABLED_EXPR = r"""items: let
  names = builtins.attrNames items;
  results = map (n: let r = builtins.tryEval (items.${n}.enable or false); in { name = n; val = r.value or null; }) names;
in map (r: r.name) (builtins.filter (r: r.val == true) results)"""


def nix_eval(expr: str) -> list[str]:
    """Run nix eval and return parsed JSON list."""
    result = subprocess.run(
        ["nix", "eval", "--json", expr],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return []
    try:
        return sorted(json.loads(result.stdout))
    except json.JSONDecodeError:
        return []


def nix_eval_apply(attr: str, apply_expr: str) -> list[str]:
    """Run nix eval with --apply and return parsed JSON list."""
    result = subprocess.run(
        ["nix", "eval", "--json", attr, "--apply", apply_expr],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return []
    try:
        return sorted(json.loads(result.stdout))
    except json.JSONDecodeError:
        return []


def get_hm_user(config_attr: str) -> str | None:
    """Get the home-manager username for a config."""
    result = subprocess.run(
        [
            "nix",
            "eval",
            "--raw",
            f"{FLAKE}#{config_attr}.config.home-manager.users",
            "--apply",
            "x: builtins.head (builtins.attrNames x)",
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return None
    return result.stdout.strip()


def get_nixos_system(host: str, section: str) -> list[str]:
    """Get enabled system-level programs/services for a NixOS host."""
    expr = NIX_SYSTEM_ENABLED_EXPR.format(section=section)
    return nix_eval_apply(f"{FLAKE}#nixosConfigurations.{host}", expr)


def get_darwin_system(host: str, section: str) -> list[str]:
    """Get enabled system-level programs/services for a darwin host."""
    expr = NIX_DARWIN_ENABLED_EXPR.format(section=section)
    return nix_eval_apply(
        f"{FLAKE}#darwinConfigurations.{host}.config.{section}", expr
    )


def get_hm(config_type: str, host: str, section: str) -> list[str]:
    """Get enabled home-manager programs/services for a host."""
    config_attr = f"{config_type}.{host}"
    user = get_hm_user(config_attr)
    if not user:
        return []
    return nix_eval_apply(
        f"{FLAKE}#{config_attr}.config.home-manager.users.{user}.{section}",
        NIX_HM_ENABLED_EXPR,
    )


def print_table(title: str, data: dict[str, dict[str, list[str]]], hosts: list[str]):
    """Print a markdown table of enabled items per host."""
    all_items = sorted({item for host_data in data.values() for item in host_data})
    if not all_items:
        return

    print(f"\n## {title}\n")
    header = f"| {'Name':<32} |"
    sep = f"|{'-' * 34}|"
    for host in hosts:
        header += f" {host:^5} |"
        sep += f"{'-' * 7}|"
    print(header)
    print(sep)

    for item in all_items:
        row = f"| {item:<32} |"
        for host in hosts:
            marker = "Y" if item in data[host] else "-"
            row += f"  {marker:<4} |"
        print(row)


def main():
    all_hosts = NIXOS_HOSTS + DARWIN_HOSTS

    sys_programs: dict[str, list[str]] = {}
    sys_services: dict[str, list[str]] = {}
    hm_programs: dict[str, list[str]] = {}
    hm_services: dict[str, list[str]] = {}

    for host in NIXOS_HOSTS:
        print(f"Evaluating {host}...", file=sys.stderr)
        sys_programs[host] = get_nixos_system(host, "programs")
        sys_services[host] = get_nixos_system(host, "services")
        hm_programs[host] = get_hm("nixosConfigurations", host, "programs")
        hm_services[host] = get_hm("nixosConfigurations", host, "services")

    for host in DARWIN_HOSTS:
        print(f"Evaluating {host}...", file=sys.stderr)
        sys_programs[host] = get_darwin_system(host, "programs")
        sys_services[host] = get_darwin_system(host, "services")
        hm_programs[host] = get_hm("darwinConfigurations", host, "programs")
        hm_services[host] = get_hm("darwinConfigurations", host, "services")

    print_table("System Programs", sys_programs, all_hosts)
    print_table("System Services", sys_services, all_hosts)
    print_table("Home Manager Programs", hm_programs, all_hosts)
    print_table("Home Manager Services", hm_services, all_hosts)


if __name__ == "__main__":
    main()
