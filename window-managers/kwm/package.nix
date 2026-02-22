{
lib,
stdenv,
fetchFromGitHub,
withBar ? true,
withCustomConfig ? false,
scdoc,
zig_0_15,
libxkbcommon,
wayland,
wayland-protocols,
callPackage,
pkg-config,
wayland-scanner,
pixman,
fcft,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kewuaa";
  version = "unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    rev = "36dfec8d5ebb69b2c155a5c997a2aeda5b5f1465";
    hash = "sha256-HKH1TLxkOEz8CjOwUr6yvk5PcjEkDB5tAPEa6siHqHY=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    wayland
    wayland-protocols
    pixman
    fcft
    libxkbcommon
  ];

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ]
  ++ lib.optional withBar "-Dbar"
  ++ lib.optional withCustomConfig "-Dconfig"; #
})
