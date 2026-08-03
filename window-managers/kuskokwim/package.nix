{
  lib,
  python3Packages,
  fetchFromCodeberg,
  wayland,
  wayland-protocols,
  wayland-scanner,
  pkg-config,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "kuskokwim";
  version = "unstable-2026-07-29";

  pyproject = true;

  src = fetchFromCodeberg {
    owner = "ricci";
    repo = "kuskokwim";
    rev = "2b559f2bf85d5c53276b0299e766191a04d5d7eb";
    hash = "sha256-4DxWNWLOTKcw21NUOHRLDhaEsd9T+dN4kScIljdVhgg=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
  ];

  buildInputs = [
    wayland
    wayland-protocols
  ];

  dependencies = [
    python3Packages.pillow
    python3Packages.pydantic
    python3Packages.xkbcommon
  ];

  postInstall = ''
    install -Dm755 $src/config.example.toml -t $out/example/config.toml
  '';
  doCheck = false;

  meta = {
    homepage = "https://codeberg.org/ricci/kuskokwim";
    description = "Kuskokwim window manager for the River compositor (version > 0.4), written in Python";
    longDescription = ''
      Kuskokwim is a stacking window manager for the River Wayland compositor, written in Python.
      Among its features are vim-inspired composable keybindings and trackable + restartable spawned processes.
    '';
    license = with lib.licenses; [
      bsd2
      isc
    ];
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
