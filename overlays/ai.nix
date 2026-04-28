{inputs, ...}: final: prev: let
  # Upstream v0.20.3 dropped the /bin/{mkdir,cat,chmod} string literals from
  # cmd/launch/{openclaw,hermes}_test.go, so nixpkgs' postPatch --replace-fail
  # blows up. Override postPatch to only run the version bump + rm -r app.
  ollamaOverride = oldAttrs: {
    version = "0.20.3";
    src = inputs.ollama-src;
    vendorHash = "sha256-Lc1Ktdqtv2VhJQssk8K1UOimeEjVNvDWePE9WkamCos=";
    postPatch =
      ''
        substituteInPlace version/version.go \
          --replace-fail 0.0.0 '0.20.3'
        rm -r app
      ''
      + final.lib.optionalString final.stdenv.hostPlatform.isDarwin ''
        rm ml/backend/ggml/ggml_test.go
        rm ml/nn/pooling/pooling_test.go
      '';
  };
in {
  codex = prev.codex.overrideAttrs (oldAttrs: rec {
    version = "0.121.0";
    src = inputs.codex-src;
    sourceRoot = "source/codex-rs";
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src sourceRoot;
      name = "${oldAttrs.pname}-${version}-vendor.tar.gz";
      hash = "sha256-zpQ0vg9XuarLfdZYiRIhcwLHUOdunNbOb5xLW3MPzp8=";
    };
  });
  ollama = prev.ollama.overrideAttrs ollamaOverride;
  ollama-cuda = prev.ollama-cuda.overrideAttrs ollamaOverride;
  ollama-rocm = prev.ollama-rocm.overrideAttrs ollamaOverride;
}
