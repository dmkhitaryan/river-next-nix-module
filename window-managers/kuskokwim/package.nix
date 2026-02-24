{
  python3Packages,
  fetchFromCodeberg,
  wayland,
  wayland-protocols,
  wayland-scanner,
  pkg-config,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "kuskokwim";
  version = "unstable-2026-02-23";

  pyproject = true;

  src = fetchFromCodeberg {
    owner = "ricci";
    repo = "kuskokwim";
    rev = "1980d673fcde3ccab42f6d7d3a1e7efda416354e";
    hash = "sha256-XVdMIOofuryGRMyKUlQ5ty39CcqPRTWmmWPpVyOnDFw=";
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
})
