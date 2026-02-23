    {
    lib,
    stdenv,
    fetchFromCodeberg,
    zig_0_15,
    libxkbcommon,
    wayland,
    wayland-protocols,
    callPackage,
    pkg-config,
    wayland-scanner,
    bison,
    libxml2,
    expat,
    libffi,
    }:

    stdenv.mkDerivation (finalAttrs: { # Messy build altogether, be warned.
      pname = "rijan";
      version = "unstable-2026-01-08";

      src = fetchFromCodeberg {
        owner = "ifreund";
        repo = "rijan";
        rev = "8cb3d4df0a4404774b0db28b1313b473d0456727";
        hash = "sha256-OUD5VyJtvNZhpH4ENHQt2XXMnASGD1bd4q+i2Yzzjoo=";
      };

      deps = callPackage ./build.zig.zon.nix { };

      nativeBuildInputs = [
        zig_0_15
        wayland-scanner
        wayland-protocols
        pkg-config
        bison
      ];
      buildInputs = [
        libxkbcommon
        wayland
        libxml2
        expat
        libffi
      ];

      postInstall = ''
        install -Dm755 $src/example/init.janet -t $out/example/
      '';

      doInstallCheck = true;

      zigBuildFlags = [
        "--system"
        "${finalAttrs.deps}"
      ] ++ [ "-Doptimize=ReleaseSafe" ];

    })
