{
  pkgs,
  lib,
  ...
}: let
  # Local fvs2 packaging — drop once https://github.com/NixOS/nixpkgs/pull/511730 lands.
  fvs2-core-src = pkgs.fetchFromGitHub {
    owner = "fvs-lab";
    repo = "core";
    rev = "v0.0.1";
    hash = "sha256-IBNNa5LGjtPNWhI0PC0NX8rK8z2LnfzOpKpDE1TZQhw=";
  };

  fvs2 = pkgs.buildGoModule rec {
    pname = "fvs2";
    version = "0.1.5";

    src = pkgs.fetchFromGitHub {
      owner = "fvs-lab";
      repo = "fvs2";
      rev = "v${version}";
      hash = "sha256-YFtHWtkAPxHT2BqJyyKpPPwkrYyDoFEHq76mNPczJjI=";
    };

    postPatch = ''
      cp -r ${fvs2-core-src} ./fvs-v2-core
      chmod -R +w ./fvs-v2-core
      substituteInPlace go.mod \
        --replace-fail 'replace fvs-v2-core => ../core' 'replace fvs-v2-core => ./fvs-v2-core'
    '';

    vendorHash = "sha256-CL37vnQ89YAnPV8cr6VvQnvSIRGkf3Mjig9fZ65A+8E=";
    subPackages = ["cmd/fvs2"];

    meta = {
      description = "File Versioning System v2 — used by Bottles for state versioning";
      homepage = "https://github.com/fvs-lab/fvs2";
      license = lib.licenses.gpl3Plus;
      mainProgram = "fvs2";
    };
  };
in {
  environment.systemPackages = [
    (pkgs.bottles.override {
      extraPkgs = _: [fvs2];
      removeWarningPopup = true;
    })
  ];
}
