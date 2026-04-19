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
    river-next = pkgs.callPackage ./river-next.nix { };
    anvl = pkgs.callPackage ./window-managers/anvl/package.nix { };
    ashrwm = pkgs.callPackage ./window-managers/ashrwm/package.nix { };
    beansprout = pkgs.callPackage ./window-managers/beansprout/package.nix { };
    bridge = pkgs.callPackage ./window-managers/bridge/package.nix { };
    canoe = pkgs.callPackage ./window-managers/canoe/package.nix { };
    cow = pkgs.callPackage ./window-managers/cow/package.nix { };
    kuskokwim = pkgs.callPackage ./window-managers/kuskokwim/package.nix { };
    kwm = pkgs.callPackage ./window-managers/kwm/package.nix { };
    machi = pkgs.callPackage ./window-managers/machi/package.nix { };
    mousetrap = pkgs.callPackage ./window-managers/mousetrap/package.nix { };
    notion-river = pkgs.callPackage ./window-managers/notion-river/package.nix { };
    orilla = pkgs.callPackage ./window-managers/orilla/package.nix { };
    pwm = pkgs.callPackage ./window-managers/pwm/package.nix { };
    rhine = pkgs.callPackage ./window-managers/rhine/package.nix { };
    rijan = pkgs.callPackage ./window-managers/rijan/package.nix { };
    rill = pkgs.callPackage ./window-managers/rill/package.nix { };
    rrwm = pkgs.callPackage ./window-managers/rrwm/package.nix { };
    tarazed = pkgs.callPackage ./window-managers/tarazed/package.nix { };
    zrwm = pkgs.callPackage ./window-managers/zrwm/package.nix { };
    reka = pkgs.callPackage ./window-managers/reka/package.nix { };

    channel = pkgs.callPackage ./channel/package.nix { };
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

    package =
      mkOption {
        type = types.nullOr types.package;
        default = localPkgs.river-next;
        description = ''
          Sets the package to use for `river-next`. Can also be nulled.
          Note that if the package of choice does not support `xwaylandSupport`
          or `withManpages` ,then the module options {option}`xwayland` and
          {option}`manpages` will have no effect.
        '';
      }
      // {
        apply =
          p:
          if p == null then
            null
          else
            p.override {
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
      type = types.unique { message = "Duplicate window manager entries are not allowed."; } (
        types.listOf (
          types.enum [
            "anvl"
            "ashrwm"
            "beansprout"
            "bridge"
            "canoe"
            "cow"
            "kuskokwim"
            "kwm"
            "machi"
            "mousetrap"
            "notion-river"
            "orilla"
            "pwm"
            "reka"
            "rhine"
            "rijan"
            "rill"
            "rrwm"
            "tarazed"
            "zrwm"
          ]
        )
      );
      default = [ ];
      description = "List of window managers to enable. Multiple can be enabled at once.";
    };

    extraPackages = mkOption {
      type = types.listOf (types.package);
      default = with pkgs; [
        fuzzel
        foot
      ];
      example = lib.literalExpression ''
        with pkgs; [ rofi alacritty swaylock ]
      '';
      description = "List of extra packages to include. Will be installed system-wide.";
    };

    kanshi = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the kanshi output configuration daemon. When enabled, kanshi is
          started as a systemd user service after River's compositor is ready but
          before a window manager is launched.
        '';
      };

      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        example = ''
          profile "home" {
            output "eDP-1" mode 1920x1080 position 0,0
            output "HDMI-A-1" mode 2560x1440 position 1920,0
          }
        '';
        description = ''
          Contents of the kanshi config file. When set, kanshi will
          started with `-c <path>` pointing to it. When null,
          kanshi will use its default search paths (e.g. ~/.config/kanshi/config).
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages =
        lib.optional (cfg.package != null) cfg.package
        ++ lib.optional cfg.kanshi.enable pkgs.kanshi
        ++ lib.optional (builtins.elem "rhine" cfg.windowManagers) localPkgs.channel
        ++ cfg.extraPackages
        ++ selectedWMs;

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        wlr = {
          enable = true;
          settings = {
            screencast = {
              chooser_type = "simple";
              chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o";
            };
          };
        };
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.river.default = lib.mkDefault [
          "gtk"
          "wlr"
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

      services = {
        emacs.enable = builtins.elem "reka" cfg.windowManagers;
      };

      services.graphical-desktop.enable = true;
      services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;

      systemd.user.targets.river-session = {
        description = "River compositor session";
        requires = [ "graphical-session-pre.target" ];
        bindsTo = [ "graphical-session-pre.target" ];
      };

      systemd.user.services.river-portal-fixer = {
        description = "Restart portals once River session environment is ready";
        bindsTo = [ "river-session.target" ];
        wantedBy = [ "river-session.target" ];
        after = [ "river-session.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          # Env vars are already imported by the init script before river-session.target
          # starts, so we just need to restart the portals/wireplumber against the
          # now-populated environment.
          ExecStart = pkgs.writeShellScript "river-portal-restart" ''
            ${pkgs.systemd}/bin/systemctl --user stop wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
            ${pkgs.systemd}/bin/systemctl --user start wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
            ${pkgs.systemd}/bin/systemctl --user import-environment PATH
            ${pkgs.systemd}/bin/systemctl --user restart xdg-desktop-portal.service
          '';
        };
      };
      services.displayManager.sessionPackages =
        lib.optional (cfg.package != null) cfg.package
        ++ (map (
          windowManager:
          let
            initScript = pkgs.writeShellScript "river-${windowManager}-init" ''
              export XDG_CURRENT_DESKTOP=river

              ${pkgs.systemd}/bin/systemctl --user import-environment \
                WAYLAND_DISPLAY \
                XDG_CURRENT_DESKTOP \
                XDG_RUNTIME_DIR \
                DISPLAY
              ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
                WAYLAND_DISPLAY \
                XDG_CURRENT_DESKTOP \
                XDG_RUNTIME_DIR \
                DISPLAY

              ${pkgs.systemd}/bin/systemctl --user start river-session.target

              ${lib.optionalString cfg.kanshi.enable ''
                ${
                  let
                    configFlag = lib.optionalString (
                      cfg.kanshi.config != null
                    ) " -c ${pkgs.writeText "kanshi-config" cfg.kanshi.config}";
                  in
                  "${pkgs.kanshi}/bin/kanshi${configFlag}"
                } &
              ''}

              ${lib.optionalString (windowManager == "rhine") ''
                ${localPkgs.channel}/bin/channel &
              ''}

              exec /run/current-system/sw/bin/${windowManager}
            '';
            launcher = pkgs.writeShellScript "river-${windowManager}-launcher" ''
              ${
                if windowManager == "reka" then
                  ''
                    exec dbus-run-session -- /run/current-system/sw/bin/river -c \
                      "${pkgs.emacs}/bin/emacs \
                        --directory ${localPkgs.reka.reka-lib}/share/emacs/site-lisp \
                        --directory ${localPkgs.reka}/share/emacs/site-lisp"
                  ''
                else
                  ''
                    exec dbus-run-session -- /run/current-system/sw/bin/river -c ${initScript}
                  ''
              }
            '';
          in
          pkgs.writeTextFile {
            name = "river-${windowManager}-session";
            destination = "/share/wayland-sessions/river-${windowManager}.desktop";
            text = ''
              [Desktop Entry]
              Name=River (${windowManager})
              Type=Application
              Comment=Launch River with ${windowManager} as window manager.
              Exec=${launcher}
            '';
            passthru.providedSessions = [ "river-${windowManager}" ];
          }
        ) cfg.windowManagers);
    }
  ]);
}
