#!/usr/bin/env python3
"""Check pinned flake inputs for upstream updates.

Detects inputs whose URL pins a tag (e.g. `v0.54.3`) or a 40-char commit hash
and compares against the latest GitHub release / default-branch HEAD.

Usage:
    scripts/check-flake-updates.py            # report only
    scripts/check-flake-updates.py --update   # rewrite tag refs in flake.nix
    scripts/check-flake-updates.py -i hyprland -i ollama-src

Auth:
    Set GITHUB_TOKEN to raise the API rate limit (60/hr → 5000/hr).
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
FLAKE_NIX = REPO / "flake.nix"
FLAKE_LOCK = REPO / "flake.lock"

# Refs treated as branch-tracking (skip — `nix flake update <name>` handles them).
BRANCH_REFS = {"main", "master", "dev", "develop", "trunk", "latest", "HEAD"}
BRANCH_PATTERNS = [
    re.compile(r"^nixos-\d"),
    re.compile(r"^nixpkgs-"),
    re.compile(r"^release-\d"),
    re.compile(r"^anyrun-update$"),
]
TAG_PATTERN = re.compile(r"\d+\.\d+")  # matches anything with a `N.M` segment (e.g. v0.54.3, rust-v0.121.0)
SHA_PATTERN = re.compile(r"^[0-9a-f]{40}$")


@dataclass
class Pin:
    name: str
    owner: str
    repo: str
    kind: str           # "tag" or "rev"
    current: str        # current ref or short rev
    locked_rev: str
    original_ref: str | None
    original_rev: str | None


def gh_get(path: str) -> dict | list | None:
    url = f"https://api.github.com{path}"
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json"})
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    try:
        with urllib.request.urlopen(req, timeout=15) as r:
            return json.load(r)
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return None
        print(f"  ! GitHub API {e.code} for {path}", file=sys.stderr)
        return None
    except urllib.error.URLError as e:
        print(f"  ! Network error for {path}: {e}", file=sys.stderr)
        return None


def latest_release_tag(owner: str, repo: str) -> str | None:
    data = gh_get(f"/repos/{owner}/{repo}/releases/latest")
    if isinstance(data, dict):
        return data.get("tag_name")
    # Fall back to most recent tag when no releases are published.
    tags = gh_get(f"/repos/{owner}/{repo}/tags?per_page=1")
    if isinstance(tags, list) and tags:
        return tags[0].get("name")
    return None


def default_branch_head(owner: str, repo: str) -> tuple[str | None, str | None]:
    repo_info = gh_get(f"/repos/{owner}/{repo}")
    if not isinstance(repo_info, dict):
        return None, None
    branch = repo_info.get("default_branch")
    if not branch:
        return None, None
    br = gh_get(f"/repos/{owner}/{repo}/branches/{branch}")
    if isinstance(br, dict):
        sha = br.get("commit", {}).get("sha")
        return branch, sha
    return branch, None


def is_branch_ref(ref: str) -> bool:
    if ref in BRANCH_REFS:
        return True
    return any(p.match(ref) for p in BRANCH_PATTERNS)


def collect_pins(lock: dict, only: set[str] | None) -> list[Pin]:
    nodes = lock.get("nodes", {})
    root_inputs = nodes.get("root", {}).get("inputs", {})
    pins: list[Pin] = []
    for name, ref_target in root_inputs.items():
        if only and name not in only:
            continue
        # `inputs` values can be a string node name or a list path.
        node_name = ref_target if isinstance(ref_target, str) else ref_target[0]
        node = nodes.get(node_name, {})
        original = node.get("original", {})
        locked = node.get("locked", {})
        if original.get("type") != "github":
            continue
        owner = original.get("owner")
        repo = original.get("repo")
        if not owner or not repo:
            continue
        ref = original.get("ref")
        rev = original.get("rev")
        locked_rev = locked.get("rev", "")
        if rev and SHA_PATTERN.match(rev):
            pins.append(Pin(name, owner, repo, "rev", rev[:12], locked_rev, ref, rev))
            continue
        if ref:
            if is_branch_ref(ref):
                continue
            if TAG_PATTERN.search(ref):
                pins.append(Pin(name, owner, repo, "tag", ref, locked_rev, ref, None))
            # else: unknown ref shape (e.g. custom branch) — skip silently
    return pins


def update_tag_in_flake(name: str, old_ref: str, new_ref: str) -> bool:
    """Replace `github:owner/repo/<old_ref>` with new_ref inside the named input block."""
    text = FLAKE_NIX.read_text()
    block_re = re.compile(
        rf'(^\s*{re.escape(name)}\s*=\s*\{{[^}}]*?url\s*=\s*"github:[^/"]+/[^/"]+/){re.escape(old_ref)}(")',
        re.MULTILINE | re.DOTALL,
    )
    new_text, n = block_re.subn(rf"\g<1>{new_ref}\g<2>", text, count=1)
    if n == 0:
        return False
    FLAKE_NIX.write_text(new_text)
    return True


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("-i", "--input", action="append", dest="inputs",
                    help="Limit to specific input names (repeatable)")
    ap.add_argument("--update", action="store_true",
                    help="Rewrite tag refs in flake.nix when newer tags are found")
    ap.add_argument("--include-revs", action="store_true",
                    help="Also report commit-pinned inputs (cannot auto-update; print suggested SHA)")
    args = ap.parse_args()

    lock = json.loads(FLAKE_LOCK.read_text())
    only = set(args.inputs) if args.inputs else None
    pins = collect_pins(lock, only)
    if not pins:
        print("No pinned github inputs found.")
        return 0

    updates: list[tuple[Pin, str]] = []
    print(f"{'INPUT':<28} {'KIND':<5} {'CURRENT':<22} {'LATEST':<22} STATUS")
    for p in pins:
        if p.kind == "tag":
            latest = latest_release_tag(p.owner, p.repo)
            status = "?" if not latest else ("up-to-date" if latest == p.current else "UPDATE")
            print(f"{p.name:<28} {p.kind:<5} {p.current:<22} {(latest or '-'):<22} {status}")
            if latest and latest != p.current:
                updates.append((p, latest))
        elif p.kind == "rev":
            if not args.include_revs:
                print(f"{p.name:<28} {p.kind:<5} {p.current:<22} {'(use --include-revs)':<22} skipped")
                continue
            branch, sha = default_branch_head(p.owner, p.repo)
            short = sha[:12] if sha else "-"
            status = "?" if not sha else ("up-to-date" if sha == p.original_rev else f"UPDATE on {branch}")
            print(f"{p.name:<28} {p.kind:<5} {p.current:<22} {short:<22} {status}")

    if args.update and updates:
        print("\nApplying tag updates to flake.nix:")
        for p, new_ref in updates:
            ok = update_tag_in_flake(p.name, p.current, new_ref)
            print(f"  {p.name}: {p.current} -> {new_ref} {'(ok)' if ok else '(NOT FOUND in flake.nix)'}")
        print("\nNext: `nix flake lock --update-input <name>` for each updated input,")
        print("then build to verify.")
    elif updates and not args.update:
        print(f"\n{len(updates)} update(s) available. Re-run with --update to apply.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
