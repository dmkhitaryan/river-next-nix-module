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
  version = "unstable-2026-05-23";

  src = fetchFromCodeberg {
    owner = "machi";
    repo = "machi";
    rev = "d51761e4b0153d95598fd50621887c2b50102169";
    hash = "sha256-0ZQ8vLAbS+UJtGzj6uo29wfX+O/BG5OxbjWCHlbJzxg=";
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
