{
  lib,
  fetchFromGitHub,
  libinput,
  libxcb,
  libxkbcommon,
  pcre2,
  pixman,
  pkg-config,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  meson,
  ninja,
  mmsg,
  scenefx,
  wlroots_0_19,
  libGL,
}: let
  pname = "mango";
  # Use patched wlroots from github.com/DreamMaoMao/wlroots
  wlroots-git = wlroots_0_19.overrideAttrs (
    final: prev: {
      src = fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "wlroots";
        rev = "afbb5b7c2b14152730b57aa11119b1b16a299d5b";
        sha256 = "sha256-pVU+CuiqvduMTpsnDHX/+EWY2qxHX2lXKiVzdGtcnYY=";
      };
      NIX_CFLAGS_COMPILE = "-Dxwayland=disabled";
    }
  );
in
  stdenv.mkDerivation {
    inherit pname;
    version = "nightly";

    src = builtins.path {
      path = ../.;
      name = "source";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      wayland-scanner
    ];

    buildInputs =
      [
        libinput
        libxcb
        libxkbcommon
        pcre2
        pixman
        wayland
        wayland-protocols
        wlroots-git
        scenefx
        libGL
      ];

    passthru = {
      providedSessions = ["mango"];
      inherit mmsg;
    };

    meta = {
      mainProgram = "mango";
      description = "A streamlined but feature-rich Wayland compositor";
      homepage = "https://github.com/DreamMaoMao/mango";
      license = lib.licenses.gpl3Plus;
      maintainers = [];
      platforms = lib.platforms.unix;
    };
  }
