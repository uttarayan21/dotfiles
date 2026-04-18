{inputs, ...}: final: prev: {
  kitty = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.kitty;
  yabai = prev.yabai.overrideAttrs (oldAttrs: rec {
    version = "7.1.16";
    src = final.fetchzip {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      hash = "sha256-rEO+qcat6heF3qrypJ02Ivd2n0cEmiC/cNUN53oia4w=";
    };
  });
}
