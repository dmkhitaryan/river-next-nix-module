{
  lib,
  stdenv,
  fetchFromCodeberg,
  withManpages ? true,
  scdoc,
  zig,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rill";
  version = "unstable-2026-10-01";

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    rev = "b35a0fd022e015f0c3e43f892555d73e0643bcfa";
    hash = "sha256-vVXE0OF2qZI/LIzzOAoaoT7+ARcVI+cftSXdQ6pniTQ=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
  ]
  ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 $src/config.zon -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

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
