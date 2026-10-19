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
  version = "unstable-2026-10-18";

  src = fetchFromGitHub {
    owner = "greenm01";
    repo = "triad";
    rev = "2a10ab637fcb1a565a77f0c3f97ecfb77790f814";
    hash = "sha256-VTh5vk5pl8M6HOabiAk30uVkbCdoztSFl3rc6RYdw5Q=";
  };

  lockFile = ./triad-nim-lock.json;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    wayland
    libxkbcommon
    pixman
  ];

  doCheck = false;

  postPatch = ''
    substituteInPlace src/session/live_paths.nim \
      --replace-fail "  result = cwd" "  result = \"$out/share/triad/live-src\"" \
      --replace-fail 'envOrDefault("TRIAD_LIVE_BIN_DIR", getHomeDir() / ".local/bin").expandTilde()' \
        "envOrDefault(\"TRIAD_LIVE_BIN_DIR\", \"$out/share/triad/live-src\").expandTilde()"
  '';

  nimFlags = [
    "--path:src"
    "-d:release"
    "--opt:speed"
  ];

  postInstall = ''
    install -Dm644 config.default.kdl $out/share/triad/config.default.kdl
    mkdir -p $out/share/triad/live-src/tools
    install -Dm755 tools/triad-manager-loop.sh $out/share/triad/live-src/tools/triad-manager-loop.sh
    install -Dm755 tools/river-triad-session.sh $out/share/triad/live-src/tools/river-triad-session.sh
    ln -s tools/triad-manager-loop.sh $out/share/triad/live-src/triad-manager-loop
    ln -s tools/river-triad-session.sh $out/share/triad/live-src/river-triad-session
    ln -s $out/bin/triad $out/share/triad/live-src/triad
    ln -s $out/bin/triad_niri $out/share/triad/live-src/triad_niri
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
