{
  lib,
  stdenv,
  fetchgit,
  fetchurl,
  janet,
  jpm,
  patchelf,
  pkg-config,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  wayland-scanner,
  mdbook,
}:

let
  river-next = callPackage ../../river-next.nix { };

  wayland-scanner_1_25 = wayland-scanner.overrideAttrs (_: {
    version = "1.25.0";
    src = fetchurl {
      url = "https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.25.0/downloads/wayland-1.25.0.tar.xz";
      hash = "sha256-wGXwQK/f8xd2gGAPJJcn5Boa/CL8zyciLxX1MG+qHwM=";
    };
  });

  wayland_1_25 = wayland.overrideAttrs (prev: {
    version = "1.25.0";
    src = fetchurl {
      url = "https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.25.0/downloads/wayland-1.25.0.tar.xz";
      hash = "sha256-wGXwQK/f8xd2gGAPJJcn5Boa/CL8zyciLxX1MG+qHwM=";
    };
    nativeBuildInputs = map
      (drv: if drv == wayland-scanner then wayland-scanner_1_25 else drv)
      prev.nativeBuildInputs
      ++ [ mdbook ];
  });

  buildJanetPackage =
    {
      pname,
      version ? "unstable",
      src,
      janetDeps ? [ ],
      buildInputs ? [ ],
      postPatch ? null,
      buildPhase ? null,
      installPhase ? null,
    }:
    stdenv.mkDerivation ({
      inherit pname version src buildInputs;

      nativeBuildInputs = [
        janet
        jpm
        patchelf
        pkg-config
      ];

      dontConfigure = true;
      JANET_PATH = lib.concatStringsSep ":" (map (dep: "${dep}/lib") janetDeps);
      postPatch = lib.optionalString (postPatch != null) postPatch;
      buildPhase = lib.optionalString (buildPhase != null) buildPhase;

      installPhase =
        if installPhase != null then
          installPhase
        else
          ''
            runHook preInstall
            export HOME="$TMPDIR/home"
            mkdir -p "$HOME" "$out" "$out/lib" "$out/bin" "$out/include" "$out/man"
            jpm --tree="$out" install
            runHook postInstall
          '';
    });

  sporkSrc = fetchgit {
    url = "https://github.com/janet-lang/spork";
    rev = "993887a8dbc9387af3b037418f02ef8e2b42b275";
    hash = "sha256-4oKmRjwDMRwlnntHOh3k2XG3pNxQ239Hgvw7zlokoCQ=";
  };

  lemongrassSrc = fetchgit {
    url = "https://github.com/pyrmont/lemongrass";
    rev = "906974b82ba06ed421e0c8cd9a56c6ddc4ca6820";
    hash = "sha256-OUqK57EYh6McnxnbvqoPm92eBMYM5iNaPuN6R0yZHA4=";
  };

  janetWaylandSrc = fetchgit {
    url = "https://codeberg.org/ifreund/janet-wayland";
    rev = "0aea1ae8c2b462d609fc739acceeb9ead315c07f";
    hash = "sha256-maPZ0hAvsBhRuVZt/6hlUYHkxGSbV+zwVDldqjDRRNU=";
  };

  janetXkbcommonSrc = fetchgit {
    url = "https://codeberg.org/ifreund/janet-xkbcommon";
    rev = "ce36f665a8b271d3eac0ef60a1ec77bd79b02367";
    hash = "sha256-W7X1ABu1v2+sqZ29OICiYYaFixxXo4uclYfsF4OMAPE=";
  };

  spork = buildJanetPackage {
    pname = "spork";
    version = "unstable-2026-04-20";
    src = sporkSrc;
  };

  lemongrass = buildJanetPackage {
    pname = "lemongrass";
    version = "unstable-2026-04-20";
    src = lemongrassSrc;
  };

  janetXkbcommonPkg = buildJanetPackage {
    pname = "janet-xkbcommon";
    version = "unstable-2026-04-20";
    src = janetXkbcommonSrc;
    janetDeps = [ spork ];
    buildInputs = [ libxkbcommon ];
    buildPhase = ''
      runHook preBuild
      export HOME="$TMPDIR/home"
      mkdir -p "$HOME"
      export NIX_LDFLAGS+=" -lxkbcommon"
      jpm build
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      install -d "$out/lib"
      install -Dm644 src/xkbcommon.janet "$out/lib/xkbcommon.janet"
      install -Dm755 build/xkbcommon-native.so "$out/lib/xkbcommon-native.so"
      patchelf --set-rpath "${lib.makeLibraryPath [ libxkbcommon ]}" "$out/lib/xkbcommon-native.so"
      runHook postInstall
    '';
  };

  janetWaylandPkg = buildJanetPackage {
    pname = "janet-wayland";
    version = "unstable-2026-04-20";
    src = janetWaylandSrc;
    janetDeps = [ lemongrass spork ];
    buildInputs = [ wayland_1_25 ];
    postPatch = ''
      substituteInPlace src/wayland.janet \
        --replace-fail '(string (sh/exec-slurp "pkg-config" "--variable=pkgdatadir" "wayland-scanner") "/wayland.xml")' \
          '"${wayland-scanner_1_25}/share/wayland/wayland.xml"' \
        --replace-fail '(sh/exec-slurp "pkg-config" "--variable=pkgdatadir" "wayland-protocols")' \
          '"${wayland-protocols}/share/wayland-protocols"'
    '';
    buildPhase = ''
      runHook preBuild
      export HOME="$TMPDIR/home"
      mkdir -p "$HOME"
      export NIX_LDFLAGS+=" -lwayland-client"
      jpm build
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      install -d "$out/lib"
      install -Dm644 src/wayland.janet "$out/lib/wayland.janet"
      install -Dm755 build/wayland-native.so "$out/lib/wayland-native.so"
      patchelf --set-rpath "${lib.makeLibraryPath [ wayland_1_25 ]}" "$out/lib/wayland-native.so"
      runHook postInstall
    '';
  };

  janetPath = lib.concatStringsSep ":" [
    "${spork}/lib"
    "${lemongrass}/lib"
    "${janetXkbcommonPkg}/lib"
    "${janetWaylandPkg}/lib"
  ];
in
stdenv.mkDerivation {
  pname = "ropotamo";
  version = "unstable-2026-04-20";

  src = fetchgit {
    url = "https://code.goryachev.org/ropotamo/ropotamo";
    rev = "00153d996d6400d845aff73d5e71a37d546e8587";
    hash = "sha256-DD6VcQa+Qllkg1pTcIxi9R5hPpnyI5L4R42EuHBGNSY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxkbcommon
    wayland_1_25
    wayland-protocols
  ];
  patches = [ ./ropotamo-fixes.patch ];

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace src/config.janet \
      --replace-fail ':spawn-on-startup @[]' ':spawn-on-startup @[]
                   :xkb-bindings @{}'

    substituteInPlace src/ropotamo.janet \
      --replace-fail '"protocol/river-window-management-v1.xml"' "\"${river-next}/share/river-protocols/stable/river-window-management-v1.xml\"" \
      --replace-fail '"protocol/river-xkb-bindings-v1.xml"' "\"${river-next}/share/river-protocols/stable/river-xkb-bindings-v1.xml\"" \
      --replace-fail '"protocol/river-layer-shell-v1.xml"' "\"${river-next}/share/river-protocols/stable/river-layer-shell-v1.xml\"" \
      --replace-fail '"protocol/river-input-management-v1.xml"' "\"${river-next}/share/river-protocols/stable/river-input-management-v1.xml\"" \
      --replace-fail '"protocol/river-libinput-config-v1.xml"' "\"${river-next}/share/river-protocols/stable/river-libinput-config-v1.xml\"" \
      --replace-fail '"protocol/river-xkb-config-v1.xml"' "\"${river-next}/share/river-protocols/stable/river-xkb-config-v1.xml\""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share"
    cp -r . "$out/share/ropotamo"
    install -Dm644 example/init.janet "$out/examples/init.janet"

    mkdir -p "$out/bin"
    cat > "$out/bin/ropotamo" <<EOF

    #!${stdenv.shell}
    export JANET_PATH='${janetPath}'
    exec ${janet}/bin/janet "$out/share/ropotamo/src/ropotamo.janet" "\$@"
    EOF
    chmod +x "$out/bin/ropotamo"
    runHook postInstall
  '';

  meta = {
    homepage = "https://code.goryachev.org/ropotamo/ropotamo";
    description = "StumpWM-like tiling window manager for River written in Janet";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dmkhitaryan ];
    platforms = lib.platforms.linux;
    mainProgram = "ropotamo";
  };
}
