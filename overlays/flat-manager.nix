{inputs, ...}: final: prev: let
  rev = "2b53b467d512fdc7431d6198b8d9eb99e2b018e6";
  src = prev.fetchFromGitHub {
    owner = "flatpak";
    repo = "flat-manager";
    inherit rev;
    hash = "sha256-XwLpfcwpFXUNPMTcrVuw1CO04laeWYJjww1+SAoEh48=";
  };
in {
  flat-manager = prev.rustPlatform.buildRustPackage {
    pname = "flat-manager";
    version = "0.5.1-unstable-${builtins.substring 0 7 rev}";
    inherit src;

    cargoHash = "sha256-rzflDq86bu4MOPQot7ID4Y+G//PWDXqduxwwf0OACho=";

    nativeBuildInputs = with prev; [pkg-config];
    buildInputs = with prev; [
      openssl
      postgresql.lib
      glib
      ostree
      gpgme
    ];

    # ostree binding picks up libs via pkg-config; ensure they're visible.
    PKG_CONFIG_PATH = "${prev.lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
      prev.openssl.dev
      prev.postgresql.lib
      prev.glib.dev
      prev.ostree.dev
      prev.gpgme.dev
    ]}";

    # Tests need a live postgres; skip.
    doCheck = false;

    meta = with prev.lib; {
      description = "Flatpak repo manager: build queue, signing, OSTree publishing over HTTP";
      homepage = "https://github.com/flatpak/flat-manager";
      license = with licenses; [mit asl20];
      platforms = platforms.linux;
      mainProgram = "flat-manager";
    };
  };

  flat-manager-client = final.flat-manager;
}
