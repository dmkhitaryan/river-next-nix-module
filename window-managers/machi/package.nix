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
  pname = "machi";
  version = "unstable-2026-05-27";

  src = fetchFromCodeberg {
    owner = "machi";
    repo = "machi";
    rev = "65a0fc12f2796f41f4c9cbb7e034aaa137009b01";
    hash = "sha256-StpGIGnIjtdEQ9fWdsei6n93IJOG6BG7gRKaOS9sI24=";
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

  postPatch = ''
    substituteInPlace build.zig \
      --replace-fail 'const sha = b.run(&.{ "git", "rev-parse", "HEAD" });' 'const sha = null;'
  '';

  postInstall = ''
    install -Dm755 example/machi.ini -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://codeberg.org/machi/machi";
    description = "River-based window manager with cascading windows, horizontal panels and vertical workspaces";
    longDescription = ''
      Machi（町）is a minimalist window manager with cascading windows, horizontal panels and vertical workspaces.
      It works on top of river's window management protocol.Offers single-view and split view modes.
    '';
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
