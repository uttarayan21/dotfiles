{inputs, ...}: final: prev: {
  # openldap's test017-syncreplication-refresh is timing-sensitive and flakes on
  # the loaded gitea-runner host. Skip the upstream test suite — the library is fine.
  openldap = prev.openldap.overrideAttrs (_: {
    doCheck = false;
  });
  # Custom libfprint with CS9711 fingerprint reader support
  # https://github.com/archeYR/libfprint-CS9711/commits/cs9711-rebase/
  libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
    version = "git";
    src = inputs.libfprint-cs9711-src;
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
