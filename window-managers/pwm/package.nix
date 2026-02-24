{
  python3Packages,
  fetchFromGitHub,
  wayland,
  wayland-protocols,
  wayland-scanner,
  pkg-config,
}:
let
  configFile = ./pwm.py;
in
python3Packages.buildPythonPackage (finalAttrs: {
  pname = "pwm";
  version = "unstable-2025-12-22";
  src = fetchFromGitHub {
    owner = "pinpox";
    repo = "river-pwm";
    rev = "4f0687f5da3f1368774c90666a8c7625521de4f3";
    hash = "sha256-NQpJh3VocOy+FP8zphooPOcxj+90ejGSTnwYPsw5dhE=";
  };
  pyproject = true;

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
    python3Packages.pycairo
    python3Packages.pypubsub
  ];

  postInstall = ''
    mkdir -p $out/bin
    echo '#!${python3Packages.python.interpreter}' > $out/bin/pwm
    cat ${configFile} >> $out/bin/pwm
    chmod +x $out/bin/pwm
  '';

  doCheck = false;
})
