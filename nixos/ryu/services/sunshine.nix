{
  pkgs,
  device,
  config,
  lib,
  ...
}: let
  bloodborne-icon = pkgs.fetchurl {
    url = "https://freepngimg.com/download/bloodborne/37671-3-bloodborne.png";
    sha256 = "sha256-IXM5YIBInHjYCktJGJz44bwT9eVafXPdE9oRu64DenY=";
  };

  baseApps = [
    {
      name = "Steam Big Picture";
      icon = "steam";
      detached = ["${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://open/gamepadui"];
      exclude-global-prep-cmd = "false";
      auto-detach = "true";
    }
    {
      name = "Bloodborne";
      image-path = "${bloodborne-icon}";
      auto-detach = "true";
      exclude-global-prep-cmd = "false";
      prep-cmd = [];
      detached = ["${pkgs.util-linux}/bin/taskset -c 0-15 ${pkgs.gamemode}/bin/gamemoderun ${pkgs.gamescope}/bin/gamescope -W 2560 -H 1440 -r 90 -f --adaptive-sync --force-grab-cursor -- ${pkgs.shadps4-qt-diegolix}/bin/shadps4 -g ${device.home}/Games/PS4/Bloodborne/CUSA00900/eboot.bin"];
      wait-all = true;
      exit-timeout = 5;
    }
  ];

  baseAppsJson = pkgs.writeText "sunshine-base-apps.json" (builtins.toJSON baseApps);

  appsPath = "${device.home}/.config/sunshine/apps.json";

  generateApps = pkgs.writers.writePython3Bin "sunshine-generate-apps" {flakeIgnore = ["E501" "E731"];} ''
    import configparser
    import glob
    import json
    import os
    import pathlib
    import re
    import sys

    BASE_APPS_PATH = "${baseAppsJson}"
    APPS_DIR = os.path.expanduser("~/.local/share/applications")
    OUT_PATH = os.path.expanduser("${appsPath}")
    ICON_THEME = os.path.expanduser("~/.local/share/icons/hicolor")
    STEAM_LIBRARY_CACHE = os.path.expanduser("~/.steam/steam/appcache/librarycache")

    EXCLUDED_NAMES = {
        "Steam Linux Runtime 3.0 (sniper)",
        "Proton Experimental",
        "SteamVR",
        "Prism Launcher",
        "vrmonitor",
    }
    EXCLUDED_PREFIXES = (
        "valve-",
        "discord-",
        "waydroid.",
        "wine-extension-",
        "userapp-",
        "remmina-",
        "chrome-",
        "claude-",
    )

    ICON_SIZES = ["512x512", "256x256", "192x192", "128x128", "96x96", "64x64", "48x48"]


    def steam_cover(appid: str) -> str | None:
        d = os.path.join(STEAM_LIBRARY_CACHE, appid)
        if not os.path.isdir(d):
            return None
        for fname in ("library_600x900.jpg", "library_600x900_2x.jpg", "header.jpg", "logo.png"):
            p = os.path.join(d, fname)
            if os.path.exists(p):
                return p
        candidates = [os.path.join(d, n) for n in os.listdir(d) if n.endswith(".jpg") and re.fullmatch(r"[a-f0-9]{40}\.jpg", n)]
        if candidates:
            return max(candidates, key=os.path.getsize)
        return None


    def resolve_icon(icon: str, appid: str | None) -> str | None:
        if appid:
            cover = steam_cover(appid)
            if cover:
                return cover
        if not icon:
            return None
        if os.path.isabs(icon) and os.path.exists(icon):
            return icon
        m = re.match(r"^steam_icon_(\d+)$", icon)
        if m:
            cover = steam_cover(m.group(1))
            if cover:
                return cover
        for size in ICON_SIZES:
            for ext in (".png", ".svg"):
                p = os.path.join(ICON_THEME, size, "apps", f"{icon}{ext}")
                if os.path.exists(p):
                    return p
        return None


    def parse_desktop(path: str) -> dict | None:
        cp = configparser.RawConfigParser(strict=False)
        cp.optionxform = str
        try:
            cp.read(path, encoding="utf-8")
        except Exception:
            return None
        if "Desktop Entry" not in cp:
            return None
        e = cp["Desktop Entry"]
        cats = [c for c in e.get("Categories", "").split(";") if c]
        if "Game" not in cats:
            return None
        if e.get("NoDisplay", "false").lower() == "true":
            return None
        if e.get("Hidden", "false").lower() == "true":
            return None
        name = e.get("Name", "").strip()
        if not name:
            return None
        exec_cmd = re.sub(r"%[fFuUdDnNickvm]", "", e.get("Exec", "")).strip()
        if not exec_cmd:
            return None
        m = re.search(r"steam://rungameid/(\d+)", exec_cmd)
        appid = m.group(1) if m else None
        return {"name": name, "exec": exec_cmd, "icon": e.get("Icon", "").strip(), "appid": appid}


    def main() -> int:
        with open(BASE_APPS_PATH) as f:
            apps = json.load(f)
        seen = {a["name"] for a in apps}

        for path in sorted(glob.glob(os.path.join(APPS_DIR, "*.desktop"))):
            fname = os.path.basename(path)
            if fname.startswith(EXCLUDED_PREFIXES):
                continue
            entry = parse_desktop(path)
            if entry is None:
                continue
            if entry["name"] in EXCLUDED_NAMES or entry["name"] in seen:
                continue
            app = {
                "name": entry["name"],
                "auto-detach": "true",
                "exclude-global-prep-cmd": "false",
                "prep-cmd": [],
                "detached": [entry["exec"]],
                "wait-all": True,
                "exit-timeout": 5,
            }
            icon = resolve_icon(entry["icon"], entry["appid"])
            if icon:
                app["image-path"] = icon
            apps.append(app)
            seen.add(entry["name"])

        out = pathlib.Path(OUT_PATH)
        out.parent.mkdir(parents=True, exist_ok=True)
        tmp = out.with_suffix(out.suffix + ".tmp")
        tmp.write_text(json.dumps({"env": {"PATH": "$(PATH):$(HOME)/.local/bin"}, "apps": apps}, indent=2))
        os.replace(tmp, out)
        print(f"sunshine-generate-apps: wrote {len(apps)} apps to {out}", file=sys.stderr)
        return 0


    if __name__ == "__main__":
        sys.exit(main())
  '';
in {
  networking.domains.subDomains."sunshine.darksailor.dev".a.data = device.tailscaleIp;

  systemd.user.services.sunshine.path = [
    pkgs.gamemode
    pkgs.steam
  ];

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
    settings = {
      sunshine_name = "Ryu";
      file_apps = appsPath;
    };
  };

  systemd.user.services.sunshine-apps = {
    description = "Generate Sunshine apps.json from desktop entries";
    wantedBy = ["default.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${generateApps}/bin/sunshine-generate-apps";
    };
  };

  systemd.user.paths.sunshine-apps-watch = {
    description = "Watch desktop entries to regenerate sunshine apps.json";
    wantedBy = ["default.target"];
    pathConfig = {
      PathChanged = "%h/.local/share/applications";
      Unit = "sunshine-apps.service";
    };
  };

  systemd.user.services.sunshine = {
    wants = ["sunshine-apps.service"];
    after = ["sunshine-apps.service"];
  };

  services.caddy.virtualHosts."sunshine.darksailor.dev".extraConfig = ''
    import cloudflare
    reverse_proxy localhost:${toString (
      config.services.sunshine.settings.port + 1
      /*
      Webserver is offset 1
      */
    )} {
      transport http {
        tls_insecure_skip_verify
      }
    }
  '';
}
