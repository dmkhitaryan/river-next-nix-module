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
  pname = "machi";
  version = "unstable-2026-04-06";

  src = fetchFromCodeberg {
    owner = "machi";
    repo = "machi";
    rev = "7b0fc895229c37fd5cbfbb0c7166785ceacd5927";
    hash = "sha256-aHQt92IKnj4JDnhoTl5H94GIaSafknjLhwTPKpu4hPg=";
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
