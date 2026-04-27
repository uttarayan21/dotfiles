{...}: final: prev: let
  # Upstream v0.20.3 dropped the /bin/{mkdir,cat,chmod} string literals from
  # cmd/launch/{openclaw,hermes}_test.go, so nixpkgs' postPatch --replace-fail
  # blows up. Override postPatch to only run the version bump + rm -r app.
  ollamaOverride = oldAttrs: rec {
    version = "0.20.3";
    src = final.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      tag = "v${version}";
      hash = "sha256-o9iCqdOfNMxfIyThQAOSSQZE2ZyBuyJWFr6wqvQo1A0=";
    };
    vendorHash = "sha256-Lc1Ktdqtv2VhJQssk8K1UOimeEjVNvDWePE9WkamCos=";
    postPatch =
      ''
        substituteInPlace version/version.go \
          --replace-fail 0.0.0 '${version}'
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
    src = final.fetchFromGitHub {
      owner = "openai";
      repo = "codex";
      tag = "rust-v${version}";
      hash = "sha256-wjiUMox9V5tFggNgaFyHXWhRlpPerK7W+U/eR2Ddbbc=";
    };
    sourceRoot = "${src.name}/codex-rs";
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
