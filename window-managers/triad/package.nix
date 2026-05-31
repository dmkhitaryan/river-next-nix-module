{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  pkg-config,
  wayland,
  libxkbcommon,
  pixman,
}:

buildNimPackage (finalAttrs: {
  pname = "triad";
  version = "unstable-2026-05-30";

  src = fetchFromGitHub {
    owner = "greenm01";
    repo = "triad";
    rev = "11b730fef50f33a3f9cb1ab964358257329618d9";
    hash = "sha256-JaLLQ3tlXs+nuK/NRCC1CiawTl6hqGdEVLQt/bgWGdQ=";
  };

  lockFile = ./triad-nim-lock.json;
  requiredNimVersion = 2;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    wayland
    libxkbcommon
    pixman
  ];

  doCheck = false;

  nimFlags = [
    "--path:src"
    "-d:release"
    "--opt:speed"
  ];

  postInstall = ''
    install -Dm644 config.default.kdl $out/share/triad/config.default.kdl
  '';

  meta = {
    homepage = "https://github.com/greenm01/triad";
    description = "Dynamic window-management client for River";
    longDescription = ''
      Triad is a dynamic window-management client for the River Wayland compositor.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    mainProgram = "triad";
    platforms = lib.platforms.linux;
  };
})
