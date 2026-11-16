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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rill";
  version = "unstable-2026-11-13";

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    rev = "262527e7042f765c83d734bffc3bd5eec904a244";
    hash = "sha256-6Zc6VnATw+N9sf6j74UaHIYIziOtenhgdIek953nu1I=";
  };

  deps = callPackage ./build.zig.zon.nix {};

  nativeBuildInputs = [
    zig_0_17
    wayland-scanner
    pkg-config
  ];
  buildInputs =
    [
      libxkbcommon
      wayland
      wayland-protocols
    ]
    ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 $src/config.zon -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags =
    [
      "--system"
      "${finalAttrs.deps}"
    ]
    ++ ["-Doptimize=ReleaseSafe"];

  meta = {
    homepage = "https://codeberg.org/lzj15/rill";
    description = "Minimalist scrolling window manager";
    longDescription = ''
      Rill is a minimalist scrolling window manager for river, implementing the river-window-management-v1 protocol, written in Zig.
      Rill supports animations and a live-reloadable configuration.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
