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
  version = "unstable-2026-11-03";

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    rev = "7ad79815df3ed83b9124b2c6fd2dfe4e64853db9";
    hash = "sha256-LNa+5c10h6WQtvXAH/G8ssNWFxcVvS6gNp7nJTGSnGg=";
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
