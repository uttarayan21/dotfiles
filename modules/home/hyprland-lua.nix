{
  config,
  lib,
  ...
}: let
  cfg = config.wayland.windowManager.hyprland;
  configName =
    if cfg.configType == "lua"
    then "hyprland.lua"
    else "hyprland.conf";
  relPath =
    lib.removePrefix "${config.home.homeDirectory}/"
    "${config.xdg.configHome}/hypr/${configName}";

  inherit (lib.generators) mkLuaInline;
  toLua = lib.generators.toLua {};
  isInline = v: builtins.isAttrs v && (v._type or null) == "lua-inline";

  hl = rec {
    inherit mkLuaInline;
    raw = mkLuaInline;

    # settings.env → `hl.env(name, value)`.
    env = name: value: {_args = [name value];};
    envs = lib.mapAttrsToList env;

    # Dispatchers as raw lua expressions.
    # `path`: dotted name after `hl.dsp.`, e.g. "window.float".
    # `args`: null → no args; attrset → single table arg; list → positional.
    dsp = {
      exec_cmd = cmd: mkLuaInline "hl.dsp.exec_cmd(${toLua cmd})";
      call = path: args: let
        rendered =
          if args == null
          then ""
          else if builtins.isList args
          then lib.concatMapStringsSep ", " toLua args
          else toLua args;
      in
        mkLuaInline "hl.dsp.${path}(${rendered})";
    };

    # Chain multiple dispatchers under one bind (replaces the hyprlang
    # idiom of repeating the same key for several actions).
    multi = dispatchers:
      mkLuaInline (
        "function() "
        + lib.concatMapStringsSep " " (d: "hl.dispatch(${d.expr});") dispatchers
        + " end"
      );

    # Render one bind. Spec forms:
    #   "cmd"                                 → exec_cmd shorthand
    #   <mkLuaInline>                         → raw dispatcher
    #   { exec  = "cmd"; flags? = {…}; }
    #   { dsp   = "path"; args? = {…}|[…]; flags? = {…}; }
    #   { multi = [<dispatcher> ...]; flags? = {…}; }
    #   { dispatcher = <inline>; flags? = {…}; }
    bind = keys: spec: let
      n =
        if builtins.isString spec
        then {dispatcher = dsp.exec_cmd spec;}
        else if isInline spec
        then {dispatcher = spec;}
        else if spec ? exec
        then {
          dispatcher = dsp.exec_cmd spec.exec;
          flags = spec.flags or {};
        }
        else if spec ? dsp
        then {
          dispatcher = dsp.call spec.dsp (spec.args or null);
          flags = spec.flags or {};
        }
        else if spec ? multi
        then {
          dispatcher = multi spec.multi;
          flags = spec.flags or {};
        }
        else if spec ? dispatcher
        then {
          dispatcher = spec.dispatcher;
          flags = spec.flags or {};
        }
        else throw "hl.bind: unrecognized spec for `${keys}`";
      flags = n.flags or {};
    in {
      _args = [keys n.dispatcher] ++ lib.optional (flags != {}) flags;
    };

    binds = lib.mapAttrsToList bind;

    # Generic helpers for list-shaped settings sections; each entry
    # renders as `hl.<key>({...})` (one call per entry).
    singleArg = arg: {_args = [arg];};
    windowRules = map singleArg;
    workspaceRules = map singleArg;
    animations = map singleArg;
    # curves: { name = { type = "bezier"; points = [...]; }; ... }
    curves = lib.mapAttrsToList (name: spec: {_args = [name spec];});
  };
in {
  _module.args.hl = hl;

  home.activation.verifyHyprlandConfig = lib.mkIf (cfg.enable && cfg.finalPackage != null) (
    lib.hm.dag.entryBefore ["linkGeneration"] ''
      configFile="$newGenPath/home-files/${relPath}"
      if [[ -e "$configFile" ]]; then
        run ${cfg.finalPackage}/bin/Hyprland --verify-config -c "$configFile"
      fi
    ''
  );
}
