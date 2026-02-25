{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.river-next;
  inherit (lib)
  types
  mkOption
  mkIf
  mkMerge
  ;

  localPkgs = {
    river-next = pkgs.callPackage ./river-dev.nix { };
    beansprout = pkgs.callPackage ./window-managers/beansprout/package.nix { };
    canoe = pkgs.callPackage ./window-managers/canoe/package.nix { };
    kuskokwim = pkgs.callPackage ./window-managers/kuskokwim/package.nix { };
    kwm = pkgs.callPackage ./window-managers/kwm/package.nix { };
    machi = pkgs.callPackage ./window-managers/machi/package.nix { };
    mousetrap = pkgs.callPackage ./window-managers/mousetrap/package.nix { };
    pwm = pkgs.callPackage ./window-managers/pwm/package.nix { };
    rhine = pkgs.callPackage ./window-managers/rhine/package.nix { };
    rijan = pkgs.callPackage ./window-managers/rijan/package.nix { };
    rill = pkgs.callPackage ./window-managers/rill/package.nix { };
    rrwm = pkgs.callPackage ./window-managers/rrwm/package.nix { };
    tarazed = pkgs.callPackage ./window-managers/tarazed/package.nix { };
    zrwm = pkgs.callPackage ./window-managers/zrwm/package.nix { };
  };
  selectedWMs = map (name: localPkgs.${name}) cfg.windowManagers;
in
{
  options.programs.river-next = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable new River window manager.";
    };

    package = mkOption {
      type = types.nullOr types.package;
      default = localPkgs.river-next;
      description = ''
        Sets the package to use for `river-next`. Can also be nulled.
        Note that if the package of choice does not support `xwaylandSupport`
        or `withManpages` ,then the module options {option}`xwayland` and
        {option}`manpages` will have no effect.
      '';
    } // {
      apply = p:
      if p == null then null
      else p.override {
        xwaylandSupport = cfg.xwayland.enable;
        withManpages = cfg.manpages.enable;
      };
    };

    xwayland.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable XWayland support.";
    };

    manpages.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Includes man page for River.";
    };

    windowManagers = mkOption {
      type = types.unique { message = "Duplicate window manager entries are not allowed."; } (types.listOf(types.enum [
        "beansprout"
        "canoe"
        "kuskokwim"
        "kwm"
        "machi"
        "mousetrap"
        "pwm"
        "rhine"
        "rijan"
        "rill"
        "rrwm"
        "tarazed"
        "zrwm"
      ]));
      default = [];
      description = "List of window managers to enable. Multiple can be enabled at once.";
    };

    extraPackages = mkOption {
      type = types.listOf(types.package);
      default = with pkgs; [
        fuzzel
        foot
      ];
      example = lib.literalExpression ''
        with pkgs; [ rofi alacritty swaylock ]
      '';
      description = "List of extra packages to include. Will be installed system-wide.";
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        environment.systemPackages =
          lib.optional (cfg.package != null) cfg.package
          ++ cfg.extraPackages
          ++ selectedWMs;  # Use the selectedWMs variable you defined earlier

        services.displayManager.sessionPackages =
          lib.optional (cfg.package != null) cfg.package
          ++ (map (windowManager:
            let
              wmPackage = localPkgs.${windowManager};
            in
            pkgs.writeTextFile {
              name = "river-${windowManager}-session";
              destination = "/share/wayland-sessions/river-${windowManager}.desktop";
              text = ''
                [Desktop Entry]
                Name=River (${windowManager})
                Type=Application
                Comment=Launch River with ${windowManager} as window manager.
                Exec=${cfg.package}/bin/river -c ${wmPackage}/bin/${windowManager}
              '';
              passthru.providedSessions = [ "river-${windowManager}" ];
            }) cfg.windowManagers);

        xdg.portal = {
          wlr.enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          config.river.default = lib.mkDefault [
            "wlr"
            "gtk"
          ];
        };

        security = {
          polkit.enable = true;
          pam.services.swaylock = { };
        };

        programs = {
            dconf.enable = lib.mkDefault true;
            xwayland.enable = cfg.xwayland.enable;
          };

        services.graphical-desktop.enable = true;

        services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
      }
    ]);
}
