{...}: final: prev: {
  # Custom libfprint with CS9711 fingerprint reader support
  # https://github.com/archeYR/libfprint-CS9711/commits/cs9711-rebase/
  libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
    version = "git";
    src = final.fetchFromGitHub {
      owner = "archeYR";
      repo = "libfprint-CS9711";
      rev = "c2d163fbb06d33e80a5177815bb0b8ca2f01739f";
      sha256 = "sha256-JygOJ3SybXKR3CjLxLbAZDaYCl9LuQYDQfFC8Si5oaw";
    };
    buildInputs = oldAttrs.buildInputs ++ [final.nss_latest];
    nativeBuildInputs =
      oldAttrs.nativeBuildInputs
      ++ [
        final.opencv
        final.cmake
        final.doctest
      ];
    # doctest in nixpkgs ships only headers + cmake config; meson's cmake dep emits
    # `-ldoctest` and the linker fails. Drop the sigfm-tests target — the library
    # itself is unaffected.
    postPatch =
      (oldAttrs.postPatch or "")
      + ''
        substituteInPlace libfprint/sigfm/meson.build \
          --replace-fail "doctest = dependency('doctest', required: true)" "" \
          --replace-fail "sigfm_tests = executable('sigfm-tests', ['./tests.cpp'], dependencies: [doctest, opencv], link_with: [libsigfm])" ""
      '';
  });
}
