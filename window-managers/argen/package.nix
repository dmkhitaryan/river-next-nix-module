{
  lib,
  stdenv,
  fetchFromCodeberg,
  withManpages ? true,
  scdoc,
  zig_0_17,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
  fcft,
  pixman,
  libevdev,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "argen";
  version = "unstable-2026-11-06";

  src = fetchFromCodeberg {
    owner = "pkap";
    repo = "argen";
    rev = "074a59da2396e67005dac77c29c966a8ad72e26b";
    hash = "sha256-RXg6OLvm3VWJvPCmKNR/uQNHftmCUsnZvePzoYOhTeQ=";
  };

  deps = callPackage ./build.zig.zon.nix {};

  nativeBuildInputs = [
    zig_0_17
    wayland-scanner
    pkg-config
  ];
  buildInputs =
    [
      wayland-protocols
      libxkbcommon
      wayland
      pixman
      fcft
      libevdev
    ]
    ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 example/init -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags =
    [
      "--system"
      "${finalAttrs.deps}"
    ]
    ++ ["-Doptimize=ReleaseSafe"];

  meta = {
    homepage = "https://codeberg.org/pkap/argen";
    description = "Task-oriented tiling window manager designed for keyboard + IPC workflows";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
