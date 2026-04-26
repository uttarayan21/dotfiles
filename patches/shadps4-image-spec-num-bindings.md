# shadPS4 pipeline cache assertion — bisect report

## Symptom

When `pipelineCacheEnable=true` is set in `[Vulkan]` of `config.toml` (i.e., shader cache toggle on), shadPS4 prerelease `2026-04-25-a762f70` crashes on the **second launch** of a game (first run populates the cache, second run loads it):

```
[Debug] <Critical> (shadPS4:Main) vk_pipeline_serialization.cpp:282 lambda: Assertion Failed!
Permutation 0 is already inserted at 1! (fs_fbe7c4b6)
```

The release build `v.0.15.0` (2026-03-17) does not exhibit this. Only triggers on hardware lacking `VK_AMD_shader_image_load_store_lod` (e.g., Nvidia, Intel, older AMD).

## Bisect

Range: `v.0.15.0` (good) → `Pre-release-shadPS4-2026-04-25-a762f70` (bad). 129 commits.

| Commit     | Subject                                              | Verdict |
|------------|------------------------------------------------------|---------|
| `0d3b6f7d` | shader_recompiler: Minor improvements to buffer atomics (#4242) | bad |
| `96411a17` | Imgui: translations (#4124)                          | bad |
| `2bb20e46` | waw fix (#4154)                                       | bad |
| `ec1719e4` | update current firmware version (#4144)              | bad |
| `1bb152d9` | **IMAGE_STORE_MIP fallback (#4075)**                  | **bad (first)** |
| `e6b74303` | Don't print unresolved libc and libSceFios2 stubs (#4137) | good |
| `88c34372` | Bump ccache-action (#4138)                           | good (CI-only) |

**First bad commit: `1bb152d9` — IMAGE_STORE_MIP fallback (PR #4075).**

PR: https://github.com/shadps4-emu/shadPS4/pull/4075

## Root cause

PR #4075 adds a `num_bindings` field to `Shader::ImageSpecialization` (`src/shader_recompiler/specialization.h:56`). The author left `// FIXME any pipeline cache changes needed?` next to it.

`ImageSpecialization::operator==` is `=default`, so the new field is included in equality comparison. `num_bindings` is computed at spec construction via:

```cpp
spec.num_bindings = desc.NumBindings(*info);
```

`ImageResource::NumBindings` (in `resource.h`) returns
`tsharp.last_level - tsharp.base_level + 1` for `MipStorageFallbackMode::DynamicIndex`,
otherwise `1`. The values come from runtime image sharps, which vary per draw.

Two draws of the same shader with different mip ranges produce specs that are no longer deduplicated at save-time. The cache file ends up with multiple entries that the load-time comparator collapses back to one match — tripping the `perm_idx == idx` assertion in `vk_pipeline_serialization.cpp:282`.

## Fix

Replace `=default` with an explicit `operator==` that omits `num_bindings` from equality. This restores save/load symmetric dedupe so duplicate permutations don't get written.

Patch: `shadps4-image-spec-num-bindings.patch`

Applied via `overlays/gaming.nix` to `shadps4-prerelease`.

## Reproduction

1. Build `shadps4-prerelease` (commit `a762f70`) without the patch.
2. `rm -rf ~/.local/share/shadPS4/cache/CUSA00900`.
3. Launch Bloodborne, play briefly, quit.
4. Launch again — assertion fires during shader cache load.

With the patch applied, step 4 succeeds.
