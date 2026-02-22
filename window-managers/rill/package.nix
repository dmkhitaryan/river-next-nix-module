{
lib,
stdenv,
fetchFromCodeberg,
withManpages ? true,
scdoc,
zig_0_15,
libxkbcommon,
wayland,
wayland-protocols,
callPackage,
pkg-config,
wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rill";
  version = "unstable-2026-02-20";

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    rev = "1fe1ff9b9cd3ffa0578bce7c48be5fe891c896b3";
    hash = "sha256-Y2s5K/Mj5fXLAaabQL8wzLIn6c7CobXt38R2LGlZ2Gs=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
  ] ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 assets/config.zon -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ];

})
